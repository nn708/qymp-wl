(* ::Package:: *)

button[name_,style_]:=If[style=="Default",
	Mouseover[button[name,"Basic"],button[name,"Mouseover"]],
	Block[{scheme=buttonColor[[style]]},Graphics[{
		scheme[["Grounding"]],
		Disk[{0,0},1],
		scheme[["Margin"]],Thickness[0.06],
		Circle[{0,0},0.94],
		scheme[["Body"]],
		buttonData[[name]]
	}]]
];


buttonData=<|
	"Play"->GraphicsGroup[{
		Thickness[0.08],JoinForm["Round"],CapForm["Round"],
		Triangle[{{-0.2,-0.4},{-0.2,0.4},{0.4,0}}],
		Line[{{-0.2,-0.4},{-0.2,0.4},{0.4,0},{-0.2,-0.4}}]
	}],
	"Pause"->GraphicsGroup[{
		Rectangle[{-0.4,-0.4},{-0.08,0.4},RoundingRadius->{0.1,0.1}],
		Rectangle[{0.08,-0.4},{0.4,0.4},RoundingRadius->{0.1,0.1}]
	}],
	"Stop"->GraphicsGroup[{
		Rectangle[{-0.4,-0.4},{0.4,0.4},RoundingRadius->{0.1,0.1}]
	}],
	"ArrowL"->GraphicsGroup[{
		Thickness[0.1],CapForm["Round"],JoinForm["Round"],
		Line[{{-0.4,0},{0.4,0}}],
		Line[{{0,-0.4},{-0.4,0},{0,0.4}}]
	}],
	"ArrowR"->GraphicsGroup[{
		Thickness[0.1],CapForm["Round"],JoinForm["Round"],
		Line[{{-0.4,0},{0.4,0}}],
		Line[{{0,-0.4},{0.4,0},{0,0.4}}]
	}],
	"Settings"->GraphicsGroup[{
		Thickness[0.12],
		Circle[{0,0},0.3],
		Table[Rotate[Rectangle[{-0.15,0.3},{0.15,0.53},RoundingRadius->{0.05,0.05}],\[Theta],{0,0}],{\[Theta],0,2Pi,Pi/3}]
	}],
	"Add"->GraphicsGroup[{
		Thickness[0.12],CapForm["Round"],
		Line[{{0,-0.4},{0,0.4}}],
		Line[{{-0.4,0},{0.4,0}}]
	}],
	"About"->GraphicsGroup[{
		Thickness[0.1],CapForm["Round"],
		Line[{{0,-0.44},{0,0.1}}],
		PointSize[0.1],
		Point[{0,0.44}]
	}],
	"Exit"->GraphicsGroup[{
		Thickness[0.08],JoinForm["Round"],CapForm["Round"],
		Line[{{0.24,-0.24},{0.24,-0.4},{-0.36,-0.4},{-0.36,0.4},{0.24,0.4},{0.24,0.24}}],
		Thickness[0.06],
		Line[{{0,0},{0.52,0}}],
		Line[{{0.4,0.12},{0.52,0},{0.4,-0.12}}]
	}],
	"Modify"->GraphicsGroup[{
		Thickness[0.06],JoinForm["Round"],CapForm["Round"],
		Line[{{-0.4,-0.4},{-0.36,-0.16},{0.24,0.44},{0.44,0.24},{-0.16,-0.36},{-0.4,-0.4}}],
		Line[{{0.12,-0.4},{0.4,-0.4}}],
		Thickness[0.04],
		Line[{{0.12,0.32},{0.32,0.12}}],
		Line[{{-0.12,-0.32},{-0.32,-0.12}}]
	}],
	"PrevSong"->GraphicsGroup[{
		CapForm["Round"],JoinForm["Round"],
		Line[{{-0.32,-0.36},{-0.32,0.36}}],
		Triangle[{{0.36,-0.36},{0.36,0.36},{-0.16,0}}],
		Line[{{0.36,-0.36},{0.36,0.36},{-0.16,0},{0.36,-0.36}}]
	}],
	"NextSong"->GraphicsGroup[{
		CapForm["Round"],JoinForm["Round"],
		Line[{{0.32,-0.36},{0.32,0.36}}],
		Triangle[{{-0.36,-0.36},{-0.36,0.36},{0.16,0}}],
		Line[{{-0.36,-0.36},{-0.36,0.36},{0.16,0},{-0.36,-0.36}}]
	}]
|>;


(* ::Input:: *)
(*Row[button[#,"Default"]&/@Keys[buttonData],ImageSize->{3000,60}]*)


pageSelectorData=<|
	"Prev"->GraphicsGroup[{
		Thickness[0.08],CapForm["Round"],JoinForm["Round"],
		Line[{{0.32,0.48},{-0.36,0},{0.32,-0.48}}]
	}],
	"Next"->GraphicsGroup[{
		Thickness[0.08],CapForm["Round"],JoinForm["Round"],
		Line[{{-0.32,0.48},{0.36,0},{-0.32,-0.48}}]
	}],
	"First"->GraphicsGroup[{
		Thickness[0.08],CapForm["Round"],JoinForm["Round"],
		Line[{{-0.4,-0.48},{-0.4,0.48}}],
		Line[{{0.44,0.48},{-0.16,0},{0.44,-0.48}}]
	}],
	"Last"->GraphicsGroup[{
		Thickness[0.08],CapForm["Round"],JoinForm["Round"],
		Line[{{0.4,-0.48},{0.4,0.48}}],
		Line[{{-0.44,0.48},{0.16,0},{-0.44,-0.48}}]
	}]
|>;


pageSelectorTemplate:=GraphicsGroup[{
	scheme[["Grounding"]],
	Rectangle[{-0.94,-0.94},{0.94,0.94},RoundingRadius->{0.14,0.14}],
	scheme[["Margin"]],Thickness[0.06],CapForm["Round"],JoinForm["Round"],
	Circle[{-0.7,-0.7},0.24,{Pi,3Pi/2}],
	Circle[{0.7,-0.7},0.24,{-Pi/2,0}],
	Circle[{-0.7,0.7},0.24,{Pi/2,Pi}],
	Circle[{0.7,0.7},0.24,{0,Pi/2}],
	Line[{{-0.7,-0.94},{0.7,-0.94}}],
	Line[{{-0.7,0.94},{0.7,0.94}}],
	Line[{{-0.94,-0.7},{-0.94,0.7}}],
	Line[{{0.94,-0.7},{0.94,0.7}}]
}];
pageSelector[num_Integer,style_,size_]:=Switch[style,
	"Default",
		Mouseover[pageSelector[num,"Basic",size],pageSelector[num,"Mouseover",size]],
	"Current",
		Mouseover[pageSelector[num,"Current-Basic",size],pageSelector[num,"Current-Mouseover",size]],
	_,
		Block[{scheme=pageSelectorColor[[style]]},Graphics[{
			pageSelectorTemplate,
			Text[num,BaseStyle->{
				FontWeight->If[StringContainsQ[style,"Current"],Bold,Plain],
				FontSize->size,
				FontColor->scheme[["Body"]]
			}]
		}]]
];
pageSelector[name_,style_]:=If[style=="Default",
	Mouseover[pageSelector[name,"Basic"],pageSelector[name,"Mouseover"]],
	Block[{scheme=pageSelectorColor[[style]]},Graphics[{
		pageSelectorTemplate,
		scheme[["Body"]],
		pageSelectorData[name]
	}]]
];


progressBar[prog_,len_]:=Graphics[{
	CapForm["Round"],JoinForm["Round"],
	Texture[Table[{c,1-c,1},{c,1/100,1/2,1/100}]],
	Polygon[{{-0.04,-0.96},{-0.04,0.96},{prog*len,0.96},{prog*len,-0.96}},
		VertexTextureCoordinates->{{0},{0},{1},{1}}
	],
	RGBColor["#00FFFF"],
	Disk[{0,0},0.96,{Pi/2,3Pi/2}],
	Rectangle[{0,-0.96},{0.2,0.96}],
	RGBColor["#B0B0B0"],Thickness[0.004],
	Circle[{0,0},0.96,{Pi/2,3Pi/2}],
	Circle[{len,0},0.96,{-Pi/2,Pi/2}],
	Line[{{0,0.96},{len,0.96}}],
	Line[{{0,-0.96},{len,-0.96}}],
	RGBColor["#F0F0F0"],
	Disk[{prog*len,0},1.56],
	RGBColor["#0088FF"],
	Disk[{prog*len,0},0.56],
	RGBColor["#909090"],Thickness[0.004],
	Circle[{prog*len,0},1.6],
	Circle[{prog*len,0},0.56]	
}];
