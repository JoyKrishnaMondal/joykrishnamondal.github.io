// Generated by LiveScript 1.3.1
(function(){
  var MaintainTime, ReturnStatus;
  MaintainTime = {};
  MaintainTime.OldTime = 1;
  ReturnStatus = function(){
    var Message, TimeRightNow, TimePassed, CurrentSecond;
    Message = {
      Progress: this.MileStone
    };
    TimeRightNow = new Date().getTime();
    TimePassed = TimeRightNow - MaintainTime.Start;
    CurrentSecond = Math.floor(TimePassed / 1000);
    if (CurrentSecond - 1 === MaintainTime.OldTime) {
      MaintainTime.OldTime = CurrentSecond;
      Message.Table = this.GetFrequencyTable();
    }
    self.postMessage(Message);
  };
  self.onmessage = function(Message){
    var Main, O, FileObject, reader;
    importScripts("static2.js");
    Main = {};
    O = self.require("./WebWorkerHeader.js");
    Main.Algorithm = O.Algorithm;
    FileObject = Message.data;
    reader = new FileReader();
    reader.onload = function(Result){
      Main.Algorithm.RunFunctionAtInterval(ReturnStatus);
      MaintainTime.Start = new Date().getTime();
      Main.Algorithm.Analyze(Result.currentTarget.result);
      console.log("done");
    };
    reader.readAsText(FileObject, "UTF-8");
    return;
  };
}).call(this);
