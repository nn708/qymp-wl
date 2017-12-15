(* ::Package:: *)

getPitch[dataString_,position_,tonality_]:=Module[
	{
		note,pitch,i
	},
	note=ToExpression@StringTake[dataString,{position}];
	pitch=If[note==0,None,pitchDict[[note]]+tonality];
	i=position-1;
	While[i>=1,
		Switch[StringTake[dataString,{i}],
		"#",
			pitch++,
		"b",
			pitch--,
		_,
			Break[]
		];
		i--;
	];
	i=position+1;
	While[i<=StringLength[dataString],
		Switch[StringTake[dataString,{i}],
		"'",
			pitch+=12,
		",",
			pitch-=12,
		_,
			Break[]
		];
		i++;
	];
	Return[{pitch,i}];
];
parse[filename_,"qym"]:=Module[
	{
		i,j,k,
		filedata,midchar,
		music,musicrepeat,musicclip,voicepart,track,
		instrument="Piano",instrumentList={},
		tonality=0,beat=1,speed=88,volume=1,
		pitch,time,space,tercet=0,tercetTime,
		repeatTime,chord=False,lastPitch,lastSpace,
		comment,match,timeDot,duration,frequency,
		getPitchResult
	},
	If[!FileExistsQ[filename],
		MessageDialog[TextCell["File not found!"],WindowTitle->"Error"];
		Return[];
	];
	filedata=StringJoin/@Map[ToString,Import[filename,"Table"],{2}];
	Do[
		match=StringPosition[filedata[[i]],"//",1];
		If[match!={},
			If[match[[1,1]]==1,
				filedata[[i]]="",
				filedata[[i]]=StringTake[filedata[[i]],match[[1,1]]-1];
			];
		];
	,{i,Length[filedata]}];
	filedata=Cases[filedata,Except[""]];
	If[StringTake[filedata[[1]],-1]==">",
		midchar=filedata[[1]];
		filedata=Delete[filedata,1];
		filedata=StringJoin[midchar,#]&/@filedata;
	];
	track={};
	Do[
		j=1;
		voicepart={};
		musicrepeat={};
		musicclip={};
		While[j<=StringLength[filedata[[i]]],
			midchar=StringTake[filedata[[i]],{j}];
			If[MemberQ[{"0","1","2","3","4","5","6","7"},midchar],
				getPitchResult=getPitch[filedata[[i]],j,tonality];
				If[chord,
					AppendTo[pitch,getPitchResult[[1]]];
					chord=False,
					pitch=getPitchResult[[1]];
					lastSpace=space;
					space=True;
				];
				j=getPitchResult[[2]];
				time=1;
				midchar=StringTake[filedata[[i]],{j}];
				While[j<=StringLength[filedata[[i]]] && MemberQ[{"-","_",".","^","&"},midchar],
					Switch[midchar,
					"-",
						time+=1,
					"_",
						time/=2,
					".",
						timeDot=1/2;
						While[j<=StringLength[filedata[[i]]] && StringTake[filedata[[i]],{j+1}]==".",
							timeDot/=2;
							j++;
						];
						time*=(2-timeDot),
					"^",
						space=False,
					"&",
						chord=True;
						If[!ListQ[pitch],pitch={pitch}]
					];
					j++;
					midchar=StringTake[filedata[[i]],{j}];
				];
				If[!chord,
					If[tercet>0,
						time*=tercetTime;
						tercet--;
					];
					duration=60/speed*time*beat;
					If[lastPitch==pitch && !lastSpace,
						If[space,
							musicclip[[-1,2]]+=duration*7/8;
							AppendTo[musicclip,{None,duration/8}],
							musicclip[[-1,2]]+=duration;
						],
						If[space,
							AppendTo[musicclip,{pitch,duration*7/8,instrument}];
							AppendTo[musicclip,{None,duration/8}],
							AppendTo[musicclip,{pitch,duration,instrument}];
						];
					];
					lastPitch=pitch;
				],
				Switch[midchar,
				"<",
					match=Select[Transpose[StringPosition[filedata[[i]],">"]][[1]],#>j&][[1]];
					comment=StringTake[filedata[[i]],{j+1,match-1}];
					Switch[StringTake[comment,{2}],
					"=",
						tonality=tonalityDict[[StringTake[comment,{3,StringLength@comment}]]],
					"/",
						beat=ToExpression[StringTake[comment,{3}]]/4,
					_,
						If[StringTake[comment,-1]=="%",
							volume=ToExpression[StringTake[comment,StringLength[comment]-1]]/100,
							speed=ToExpression[comment];
						];
					];
					j=match,
				"(",
					match=Select[Transpose[StringPosition[filedata[[i]],")"]][[1]],#>j&][[1]];
					comment=StringTake[filedata[[i]],{j+1,match-1}];
					tercet=ToExpression[comment];
					tercetTime=(2^Floor[Log2[tercet]])/tercet;
					j=match,
				"{",
					match=Select[Transpose[StringPosition[filedata[[i]],"}"]][[1]],#>j&][[1]];
					instrument=StringTake[filedata[[i]],{j+1,match-1}];
					instrumentList=Union[instrumentList,{instrument}];
					j=match,
				":",
					If[StringTake[filedata[[i]],{j+1}]=="|",
						If[musicrepeat=={},
							voicepart=Join[voicepart,musicclip];
							voicepart=Join[voicepart,musicclip];
							musicclip={},
							Do[
								voicepart=Join[voicepart,musicclip];
								voicepart=Join[voicepart,musicrepeat];
							,{k,repeatTime}];
							repeatTime=0;
							musicclip={}
						],
						voicepart=Join[voicepart,musicclip];
						musicclip={};
						musicrepeat={}
					],
				"[",
					match=Select[Transpose[StringPosition[filedata[[i]],"]"]][[1]],#>j&][[1]];
					repeatTime=StringCount[StringTake[filedata[[i]],{j+1,match-1}],"."];
					If[StringTake[filedata[[i]],{j+1,j+2}]=="1.",
						voicepart=Join[voicepart,musicclip];
						musicrepeat=musicclip;
						musicclip={};
					];
					j=match
				];
				j++;
			];	
		];
		voicepart=Join[voicepart,musicclip];
		If[voicepart!={},AppendTo[track,volume*Audio[Sound[SoundNote@@#&/@voicepart]]]],
	{i,Length[filedata]}];
	music=AudioOverlay@track;
	Return[Audio[music,MetaInformation-><|
		"Format"->"qym",
		"TrackCount"->Length@track,
		"Duration"->QuantityMagnitude@UnitConvert[Duration@music,"Seconds"],
		"Instruments"->instrumentList
	|>]];
]
