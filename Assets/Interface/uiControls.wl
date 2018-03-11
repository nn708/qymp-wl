(* ::Package:: *)

uiPlayerControlsOld:={
	Row[{
		Dynamic[Style[timeDisplay[current["Position"]],20]],
		Spacer[8],
		ProgressIndicator[Dynamic[current["Position"]/duration],ImageSize->{240,16}],
		Spacer[8],
		Style[timeDisplay[duration],20]
	}],Spacer[1],
	Row[{Button[
		Dynamic[Switch[current[StatusAlias],
			"Playing",text[["Pause"]],
			"Paused"|"Stopped",text[["Play"]]
		]],
		Switch[current[StatusAlias],
			"Playing",current[StatusAlias]="Paused",
			"Paused"|"Stopped",current[StatusAlias]="Playing"
		],
		ImageSize->80],
		Spacer[20],
		Button[text[["Stop"]],current[StatusAlias]="Stopped",ImageSize->80],
		Spacer[20],
		Button[text[["Return"]],AudioStop[];DialogReturn[uiPlaylist[currentPlaylist]],ImageSize->80]			
	}]
};


uiPlayerControlsNew:={
	Row[{
		Column[{Style[Dynamic[timeDisplay[current["Position"]]],20],Spacer[1]}],
		Spacer[8],
		Magnify[
			EventHandler[Dynamic@Graphics[{
				progressBar[current["Position"]/duration,16],
				progressBlock[current["Position"]/duration,16]
			}],
			{"MouseDragged":>(
				current["Position"]=duration*progressLocate[CurrentValue[{"MousePosition","Graphics"}][[1]],16]
			)}],
		3.6],
		Spacer[8],
		Column[{Style[timeDisplay[duration],20],Spacer[1]}]
	},ImageSize->Full,Alignment->Center],
	Row[{
		DynamicModule[{style="Default"},
			Dynamic@Switch[current[StatusAlias],
				"Playing",EventHandler[button["Pause",style],{
					"MouseDown":>(style="Clicked"),
					"MouseUp":>(style="Default";current[StatusAlias]="Paused")
				}],
				"Paused"|"Stopped",EventHandler[button["Play",style],{
					"MouseDown":>(style="Clicked"),
					"MouseUp":>(style="Default";current[StatusAlias]="Playing")
				}]
			]
		],
		Spacer[20],
		DynamicModule[{style="Default"},
			EventHandler[Dynamic@button["Stop",style],{
				"MouseDown":>(style="Clicked"),
				"MouseUp":>(style="Default";current[StatusAlias]="Stopped";current["Position"]=0)
			}]
		],
		Spacer[20],
		DynamicModule[{style="Default"},
			EventHandler[Dynamic@button["ArrowL",style],{
				"MouseDown":>(style="Clicked";),
				"MouseUp":>(style="Default";
					AudioStop[];
					DialogReturn[uiPlaylist[currentPlaylist]];
				)
			}]
		]		
	},ImageSize->{300,60},Alignment->Center]
};


uiPageSelector:=Row[{
	Dynamic@If[page<=1,pageSelectorDisplay["Prev","Disabled"],
	DynamicModule[{style="Default"},
		EventHandler[Dynamic@pageSelectorDisplay["Prev",style],{
			"MouseDown":>(style="Clicked"),
			"MouseUp":>(style="Default";page--;)
		}]
	]],
	Spacer[20],
	Row[Flatten@Array[{
		Dynamic@If[page==#,pageSelectorDisplay[#,"Current",32],
		DynamicModule[{style="Default"},
			EventHandler[Dynamic@pageSelectorDisplay[#,style,32],{
				"MouseDown":>(style="Clicked"),
				"MouseUp":>(style="Default";page=#;)
			}]
		]
	],Spacer[6]}&,pageCount]],
	Spacer[14],
	Dynamic@If[page>=pageCount,pageSelectorDisplay["Next","Disabled"],
	DynamicModule[{style="Default"},
		EventHandler[Dynamic@pageSelectorDisplay["Next",style],{
			"MouseDown":>(style="Clicked"),
			"MouseUp":>(style="Default";page++;)
		}]
	]]
},ImageSize->{500,60},Alignment->Center];


SetAttributes[button,HoldRest];
button[buttonName_,action_]:=DynamicModule[{style="Default"},
	EventHandler[Dynamic@buttonDisplay[buttonName,style],{
		"MouseDown":>(style="Clicked"),
		"MouseUp":>(style="Default";action;)
	}]
]
