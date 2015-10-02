// Generated by LiveScript 1.3.1
(function(){
  var TM, Main, CreateStyleJson, slice$ = [].slice;
  TM = require("./headers.js").TM;
  Main = {};
  Main.Blue5 = "rgba(48,57,150,0.6)";
  Main.Blue1 = "rgba(48,57,150,0.8)";
  Main.White = "rgb(255,255,255)";
  Main.Black = "rgb(120,120,120)";
  Main.FontSizeOfButton = "18pt";
  Main.TextBoxColor = ["rgb(234,234,234)", "rgb(255,255,255)"];
  Main.HeightOfRankingBox = 68;
  Main.HeightOfEachBoxInRankingBox = "8%";
  Main.TopLevel = {
    "width": "90%",
    "display": "flex",
    "height": "99%",
    "border-style": "solid",
    "border-width": "0px",
    "margin": "auto auto",
    "align-items": "center",
    "justify-content": "center",
    "flex-flow": "row wrap",
    "font-family": "OpenSan",
    "align-content": "center"
  };
  Main.FirstRow = {
    "width": "90%",
    "display": "flex",
    "flex-flow": "row wrap",
    "border-style": "solid",
    "border-width": "0px",
    "align-items": "center",
    "justify-content": "center",
    "margin": "1%",
    "height": "10%"
  };
  Main.UploadBox = {
    "border-style": "solid",
    height: "100%",
    width: "20%",
    "border-width": "0px",
    "display": "flex",
    "justify-content": "center",
    "align-items": "center"
  };
  Main.DownloadBox = {
    "border-style": "solid",
    height: "100%",
    width: "20%",
    "border-width": "1px",
    "display": "flex",
    "justify-content": "center",
    "margin": "0 auto",
    "font-size": Main.FontSizeOfButton,
    "align-items": "center",
    "color": Main.Blue5
  };
  Main.UploadButton = {
    "border-style": "solid",
    "height": "100%",
    "width": "100%",
    "border-width": "1px",
    "display": "flex",
    "justify-content": "center",
    "align-items": "center",
    "font-size": Main.FontSizeOfButton,
    "cursor": "pointer",
    "color": Main.Blue5,
    "-webkit-user-select": "none",
    "-moz-user-select": "none",
    "user-select": "none"
  };
  Main.ProgressBar = {
    "border-style": "solid",
    "border-width": "0px",
    "display": "flex",
    "height": "100%",
    "width": "30%",
    "font-size": "20pt",
    "align-items": "center",
    "margin-left": "1%",
    "margin-right": "1%"
  };
  Main.ProgressBarCanvas = {
    "border-style": "solid",
    "border-width": "0px",
    "height": "100%",
    "width": "100%"
  };
  Main.RankingNumber = {
    "border-style": "solid",
    "border-width": "1px",
    "display": "flex",
    "width": "25%",
    "height": "6%",
    "margin-left": "1%",
    "text-align": "center",
    "background": Main.Black,
    "color": Main.White,
    "font-size": "7pt",
    "justify-content": "center",
    "align-items": "center"
  };
  Main.RankingString = function(Color, Width){
    var Band;
    if (Color > 13) {
      Band = Color + 1;
    } else {
      Band = Color;
    }
    return {
      "border-style": "solid",
      "border-width": "0px",
      "width": Width,
      "margin-right": "1%",
      "text-align": "center",
      "font-size": "18pt",
      "color": "rgba(0,0,0,0.6)",
      "background": this.TextBoxColor[Band % 2]
    };
  };
  Main.TableTopCell = {
    "border-style": "solid",
    "border-width": "0px",
    "display": "flex",
    "height": "7.5%",
    "width": "50%",
    "font-size": "10pt",
    "font-family": "OpenSan",
    "align-items": "center"
  };
  Main.RankingCSS = {
    "display": "flex",
    "border-style": "solid",
    "border-width": "0px",
    "flex-flow": "row wrap",
    "height": Main.HeightOfRankingBox + "%",
    "width": "100%",
    "opacity": "0.9",
    "padding": "0%",
    "align-items": "center",
    "align-content": "center"
  };
  Main.Heading = function(Width){
    return {
      "display": "flex",
      "align-items": "center",
      "align-content": "center",
      "justify-content": "center",
      "width": Width,
      "font-size": "12pt",
      "margin": "0.2%",
      "color": "rgb(255,255,255)",
      "background": "rgba(0,0,0,0.55)",
      "border-style": "solid",
      "border-width": "0px",
      "border-color": "rgba(0,0,0,0.3)"
    };
  };
  Main.TableHeading = {
    display: "flex",
    justifyContent: "center",
    flexFlow: "row wrap",
    width: "100%"
  };
  Main.Table = {
    display: "flex",
    flexFlow: "column wrap",
    width: "100%",
    height: "90%"
  };
  Main.InputFileCSS = {
    display: "none"
  };
  Main.ProgressStatus = {
    "border-style": "solid",
    display: "flex",
    "border-width": "0px",
    "align-items": "center",
    "align-content": "center",
    "width": "100%",
    "text-align": "center",
    "vertical-align": "center",
    justifyContent: "center",
    "color": Main.Blue1,
    "font-size": "15pt",
    "height": "1em"
  };
  CreateStyleJson = function(fill, word){
    return {
      "background": fill,
      "color": word
    };
  };
  Main.MouseDownUploadButton = function(Elem){
    partialize$.apply(TM, [TM.to, [Elem.srcElement, 0.1, void 8], [2]])(
    CreateStyleJson(Main.Blue1, Main.White));
  };
  Main.MouseUpUploadButton = function(Time){
    return function(Elem){
      return partialize$.apply(TM, [TM.to, [Elem.srcElement, Time, void 8], [2]])(
      CreateStyleJson(Main.White, Main.Blue5));
    };
  };
  window.CSS = Main;
  function partialize$(f, args, where){
    var context = this;
    return function(){
      var params = slice$.call(arguments), i,
          len = params.length, wlen = where.length,
          ta = args ? args.concat() : [], tw = where ? where.concat() : [];
      for(i = 0; i < len; ++i) { ta[tw[0]] = params[i]; tw.shift(); }
      return len < wlen && len ?
        partialize$.apply(context, [f, ta, tw]) : f.apply(context, ta);
    };
  }
}).call(this);