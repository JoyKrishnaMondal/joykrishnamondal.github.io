// Generated by LiveScript 1.3.1
(function(){
  var Fn1, Fn2, CombineFn, List, Fn;
  Fn1 = function(Elem){
    return console.log(Elem);
  };
  Fn2 = function(){
    return console.log("Fn2");
  };
  CombineFn = function(ListFn){
    return function(Elem){
      var I, Len, Fn;
      I = 0;
      Len = ListFn.length;
      while (I < Len) {
        Fn = ListFn[I];
        Fn(Elem);
        I += 1;
      }
    };
  };
  List = [Fn1, Fn2];
  Fn = CombineFn(List);
  Fn("hello");
}).call(this);