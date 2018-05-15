(* ::Package:: *)

BeginPackage["Thulium`Interface`newPlaylist`", {
  "Thulium`System`",
  "Thulium`Assets`",
  "Thulium`SmartButton`",
  "Thulium`PageSelector`"
}];

newPlaylist::usage = "newPlaylist";

Begin["`Private`"];

newPlaylist[playlist_] := Block[
  {info, length, songList, indexList, pageCount},
  info = PlaylistIndex[playlist];
  length = Length @ info["SongList"];
  pageCount = Ceiling[length / ListSize];
  songList = Partition["Song" /. info["SongList"], UpTo @ Ceiling[length / pageCount]];
  indexList = Partition["Index" /. info["SongList"], UpTo @ Ceiling[length / pageCount]];
  If[Thulium`PageIndex[playlist] > pageCount, Thulium`PageIndex[playlist] = pageCount];
  Module[
    {page = Thulium`PageIndex[playlist], index = 1},
    CreateDialog[
      Container[With[
        {
          songList = songList, pageCount = pageCount, indexList = indexList,
          indexWidth = info["IndexWidth"],
          $Epi = Unevaluated[Thulium`PageIndex[playlist] = Dynamic[page]]
        },
        Column[{
          Row[{
            Row[{
              Caption[info[["Title"]], "BigTitle"]
            }, Alignment -> Left, ImageSize -> 400],
            Row[{
              SmartButton["Play", DialogReturn[$Epi; Thulium`Player[songList[[page, index]]]]],
              Spacer[10],
              SmartButton["Return", DialogReturn[$Epi; Thulium`homepage]]
            }, Alignment -> Right, ImageSize -> {400, 60}]
          }],
          If[info["Comment"] == "", Nothing,
            Row[{
              Caption[info[["Comment"]], "Subtitle"]
            }, Alignment -> Left, ImageSize -> 800]
          ],
          Spacer[20],
          Dynamic[
            SetterList[Dynamic[index], Table[
              Row[{
                Row[{
                  Spacer[8],
                  If[indexWidth > 0,
                    Row[{
                      Caption[indexList[[page, id]], "SongIndex"],
                      Spacer[16]
                    }, ImageSize -> indexWidth, Alignment -> Center],
                    Spacer[4]
                  ],
                  Caption[SongIndex[songList[[page, id]], "SongName"], "SongName"]
                }, Alignment -> Left, ImageSize -> 480],
                Row[{
                  Row[{"Right"}, Alignment -> Center],
                  Spacer[8]
                }, Alignment -> Right, ImageSize -> 480]
              }, Alignment -> Center, ImageSize -> {960, 32}],
            {id, Length @ songList[[page]]}]],
          TrackedSymbols :> {page}],
          Spacer[20],
          PageSelector[Dynamic[page], pageCount]
        }, Center]
      ], 100, 40],
      WindowTitle -> TagName[info["Type"]] <> " - " <> info["Title"],
      Background -> WindowBackground
    ];
  ];
];

End[];

EndPackage[];


(* ::Input:: *)
(*Thulium`Interface`newPlaylist`newPlaylist["All"];*)
