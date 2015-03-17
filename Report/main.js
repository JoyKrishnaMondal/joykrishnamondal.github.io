// Generated by LiveScript 1.3.1
(function(){
  var ref$, io, JQ, tempConv, _, TM, move, __, udc, katex, Chart, reg, log, GlobalCOe, GlobalGDP, ECommerce, CreateR, ChartArray, CreateArray, SetValArray, ElementPointers, signals, CreateSimpleChart, config;
  ref$ = require("./headers.js"), io = ref$.io, JQ = ref$.JQ, tempConv = ref$.tempConv, _ = ref$._, TM = ref$.TM, move = ref$.move, __ = ref$.__, udc = ref$.udc, katex = ref$.katex, Chart = ref$.Chart, reg = ref$.reg;
  log = function(X){
    return console.log(JSON.parse(JSON.stringify(X)));
  };
  GlobalCOe = function(pol, name){
    var y, x, vals, array, R;
    y = [14079.8, 15685.0, 18061.0, 18641.4, 20988.7, 21851.0, 23758.6, 27501.4, 28966.4, 30509.4, 31342.3, null, null, null, null, null];
    x = [1971, 1975, 1980, 1985, 1990, 1995, 2000, 2005, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2020];
    vals = reg('polynomial', _.zip(x, y), pol);
    array = vals.points;
    R = {};
    R.name = name;
    R.y = _.map(function(arr){
      return arr[1];
    }, array);
    R.Label = _.map(function(x){
      return x.toString();
    }, x);
    R.type = "Line";
    R.x = x;
    return R;
  };
  GlobalGDP = function(pol, name){
    var y, x, vals, array, R;
    y = [41016, null, null, null, null, 43070, null, null, null, null, 62220, null, null, 71830, 74909, null, null, null, null, null, null, null];
    x = [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020];
    vals = reg('polynomial', _.zip(x, y), pol);
    array = vals.points;
    R = {};
    R.name = name;
    R.y = _.map(function(arr){
      return arr[1];
    }, array);
    R.Label = _.map(function(x){
      return x.toString();
    }, x);
    R.type = "Line";
    R.x = x;
    return R;
  };
  ECommerce = function(){
    var x, y, vals, array, Label, R;
    x = [2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020];
    y = [1.233, 1.471, 1.700, 1.922, 2.143, 2.356, null, null];
    vals = reg('polynomial', _.zip(x, y), 2);
    array = vals.points;
    y = _.map(function(arr){
      return arr[1];
    }, array);
    Label = _.map(function(x){
      return x.toString();
    }, x);
    R = {};
    R.name = "ECommerce";
    R.type = "Bar";
    R.x = x;
    R.y = y;
    R.Label = Label;
    return R;
  };
  CreateR = function(R){
    R.options = {
      scaleShowGridLines: true,
      scaleGridLineColor: "rgba(0,0,0,.05)",
      scaleGridLineWidth: 1,
      bezierCurve: true,
      bezierCurveTension: 0.4,
      pointDot: true,
      pointDotRadius: 7,
      pointDotStrokeWidth: 1,
      pointHitDetectionRadius: 20,
      datasetStroke: true,
      datasetStrokeWidth: 2,
      datasetFill: true,
      legendTemplate: "<ul class=\"<%=name.toLowerCase()%>-legend\"><% for (var i=0; i<datasets.length; i++){%><li><span style=\"background-color:<%=datasets[i].lineColor%>\"></span><%if(datasets[i].label){%><%=datasets[i].label%><%}%></li><%}%></ul>"
    };
    R.data = {
      labels: R.Label,
      datasets: [{
        label: "My First dataset",
        fillColor: "rgba(176,97,97,0.3)",
        strokeColor: "rgba(220,220,220,1)",
        pointColor: "rgba(225,225,225,1)",
        pointStrokeColor: "#fff",
        pointHighlightFill: "rgba(225,225,225,1)",
        pointHighlightStroke: "rgba(220,220,220,1)",
        data: R.y
      }]
    };
    return R;
  };
  ChartArray = _.map(CreateR, [ECommerce(), GlobalGDP(3, "cube"), GlobalGDP(1, "line"), GlobalCOe(1, 'CO')]);
  CreateArray = function(size, val){
    var Arr, i$, to$, I;
    val == null && (val = 0);
    Arr = [];
    for (i$ = 0, to$ = size - 2; i$ <= to$; ++i$) {
      I = i$;
      Arr.push(val);
    }
    return Arr;
  };
  SetValArray = function(list, index, val){
    var i$, ref$, len$, I;
    for (i$ = 0, len$ = (ref$ = __.range(index, list.length)).length; i$ < len$; ++i$) {
      I = ref$[i$];
      list[I] = val;
    }
    return list;
  };
  ElementPointers = {};
  signals = {};
  signals.load = __.map((function(){
    var i$, to$, results$ = [];
    for (i$ = 1, to$ = ChartArray.length; i$ <= to$; ++i$) {
      results$.push(i$);
    }
    return results$;
  }()), function(){
    return false;
  });
  CreateSimpleChart = function(R, i){
    var f;
    f = function(element){
      var ctx, NeWChart;
      if (signals.load[i] === false) {
        console.log('foundit !');
        ctx = element.getContext("2d");
        ctx.canvas.width = window.innerWidth * 0.5;
        ctx.canvas.height = window.innerHeight / 2;
        NeWChart = new Chart(ctx)[R.type](R.data, R.options);
        return signals.load[i] = true;
      }
    };
    return f;
  };
  config = function(Name){
    var Ob;
    Ob = function(E){
      return ElementPointers[Name] = E;
    };
    return Ob;
  };
  JQ.get("test.html", function(doc){
    var Mdoc, app, Signals, Nines, cleanEnter, FindRef, Linkstyle, ChangeSourceHTML, GlobalRef, GlobalRefReal, FindCite, GlobalCite, ChangeCiteHTML, FindFigCapion, Ref, ChangeImageRefHTML, FindHeaders, CreateHeaderM, GetHeaders, NinesCompress, EditName, FoldFn, AddReferenceToHead, IndexM, Headers, GetName, ListOfNames, OnMouseClick, FadeInTriangle, FadeOutTriangle;
    Mdoc = eval(tempConv.Template(doc).toString());
    app = {};
    Signals = {};
    Signals.OpenIndex = false;
    Nines = CreateArray(7, 0);
    Nines[0] = 1;
    cleanEnter = function(doc){
      var clean;
      clean = function(x){
        if (typeof x === "object") {
          return true;
        } else {
          return false;
        }
      };
      return _.filter(clean, doc);
    };
    FindRef = function(doc){
      var GlobRef, f;
      GlobRef = [];
      f = function(x){
        if (x.attrs === undefined) {
          0;
        } else {
          if (x.attrs.tag === undefined) {
            0;
          } else {
            GlobRef.push(x);
          }
        }
        if (x.children !== undefined && x.children.length > 0) {
          return _.map(f, x.children);
        }
      };
      _.map(f, doc);
      return GlobRef;
    };
    Linkstyle = {
      "text-decoration": "none",
      "color": "black",
      "font-style": "normal"
    };
    ChangeSourceHTML = function(x){
      var copy, M;
      copy = udc(x.children);
      M = [m("a", {
        style: Linkstyle,
        name: x.attrs.tag,
        href: x.attrs.href
      }, copy)];
      return x.children = M;
    };
    GlobalRef = FindRef(cleanEnter(Mdoc));
    GlobalRefReal = udc(GlobalRef);
    _.map(ChangeSourceHTML, GlobalRef);
    FindCite = function(doc){
      var GlobCite, f;
      GlobCite = [];
      f = function(x){
        if (x.tag === "cite") {
          return GlobCite.push(x);
        } else if (x.children === undefined) {
          return 0;
        } else if (x.children.length > 0) {
          return _.map(f, x.children);
        }
      };
      _.map(f, doc);
      return GlobCite;
    };
    GlobalCite = FindCite(cleanEnter(Mdoc));
    FindRef = function(name){
      var i$, to$, I;
      if (GlobalRefReal.length === 0) {
        console.log("Reference List is zero");
      } else {
        for (i$ = 0, to$ = GlobalRefReal.length; i$ <= to$; ++i$) {
          I = i$;
          if (GlobalRefReal[I].attrs.tag === name) {
            return I;
          }
        }
        return console.log("Couldn't Find Reference");
      }
    };
    ChangeCiteHTML = function(x){
      var name, M;
      name = x.children[0];
      M = m("a", {
        style: Linkstyle,
        href: "#" + name
      }, ["[" + (FindRef(name) + 1) + "]"]);
      return x.children = [M];
    };
    _.map(ChangeCiteHTML, GlobalCite);
    FindFigCapion = function(doc){
      var GlobRef, f;
      GlobRef = {};
      GlobRef.FigRef = [];
      GlobRef.ImageRef = [];
      GlobRef.equ = [];
      GlobRef.equIn = [];
      GlobRef.equRef = [];
      GlobRef.Charts = [];
      f = function(x){
        if (x.tag === "figcaption") {
          return GlobRef.FigRef.push(x);
        } else if (x.tag === "imageref") {
          return GlobRef.ImageRef.push(x);
        } else if (x.tag === "equ") {
          return GlobRef.equ.push(x);
        } else if (x.tag === "equin") {
          return GlobRef.equIn.push(x);
        } else if (x.tag === "equref") {
          return GlobRef.equRef.push(x);
        } else if (x.tag === "chart") {
          return GlobRef.Charts.push(x);
        } else if (x.children === undefined) {
          return 0;
        } else if (x.children.length > 0) {
          return _.map(f, x.children);
        }
      };
      _.map(f, doc);
      return GlobRef;
    };
    Ref = FindFigCapion(cleanEnter(Mdoc));
    ChangeImageRefHTML = function(RefOb){
      var FindEqu, g, line, FindImage, f, h, style, t, Cinsert;
      FindEqu = function(name){
        var i$, to$, I;
        for (i$ = 0, to$ = RefOb.equ.length - 1; i$ <= to$; ++i$) {
          I = i$;
          if (RefOb.equ[I].attrs.name === name) {
            return I;
          }
        }
        return console.log("Couldnt Find equation Reference for:");
      };
      g = function(x, i){
        var name, href, temp, CENTER, LEFT;
        name = x.children[0];
        href = x.attrs.name;
        temp = eval(tempConv.Template(katex.renderToString(name)).toString());
        CENTER = m("a", {
          name: href,
          style: {
            "text-align": "center",
            "text-decoration": "none"
          }
        }, temp);
        LEFT = m("span", {
          style: {
            "float": "right"
          }
        }, "(" + (i + 1) + ")");
        return x.children = [m("div", {
          style: {
            "text-align": "center"
          }
        }, [CENTER, LEFT])];
      };
      line = function(x){
        var name, temp;
        name = x.children[0];
        temp = eval(tempConv.Template(katex.renderToString(name)).toString());
        return x.children = temp;
      };
      FindImage = function(name){
        var i$, to$, I;
        for (i$ = 0, to$ = RefOb.FigRef.length - 1; i$ <= to$; ++i$) {
          I = i$;
          if (RefOb.FigRef[I].attrs.caption === name) {
            return I;
          }
        }
        return null;
      };
      f = function(x){
        var name, val, M;
        name = x.children[0];
        val = FindImage(name);
        if (val !== null) {
          M = "Figure " + (val + 1);
          return x.children = [M];
        }
      };
      _.map(f, RefOb.ImageRef);
      h = function(x, i){
        var string, M;
        string = x.children;
        M = __.flatten([m("span", "Figure " + (i + 1) + " - "), string]);
        return x.children = M;
      };
      style = {
        "text-decoration": "none",
        "color": "black"
      };
      t = function(x){
        var name, val, M;
        name = x.children[0];
        val = FindEqu(name);
        M = m("a", {
          style: style,
          href: "#" + name
        }, "(" + (val + 1) + ")");
        return x.children = [M];
      };
      Cinsert = function(x){
        var child, name;
        child = x.children[0];
        return name = __.each(ChartArray, function(y, i){
          var con, chart;
          console.log(i);
          if (y.name === child) {
            con = CreateSimpleChart(y, i);
            chart = m("center", m("canvas", {
              config: con
            }));
            return x.children = [chart];
          }
        });
      };
      if (RefOb.equRef.length !== 0) {
        _.map(t, RefOb.equRef);
      }
      if (RefOb.equ.length !== 0) {
        __.each(RefOb.equ, g);
      }
      if (RefOb.equIn.length !== 0) {
        __.each(RefOb.equIn, line);
      }
      if (RefOb.ImageRef.length !== 0) {
        _.map(f, RefOb.ImageRef);
      }
      if (RefOb.FigRef.length !== 0) {
        __.each(RefOb.FigRef, h);
      }
      if (RefOb.Charts.length !== 0) {
        return __.each(RefOb.Charts, Cinsert);
      }
    };
    ChangeImageRefHTML(Ref);
    FindHeaders = function(doc){
      var listofHeaders, Output, Search;
      listofHeaders = [];
      Output = {};
      Search = function(elem, dept){
        var Output, find;
        Output = {};
        if (typeof elem === "string") {
          return;
        }
        find = /h([2-9])/.exec(elem.tag);
        if (find !== null) {
          Output.name = elem.children[0];
          Output.height = find[1];
          Output.dept = dept;
          return listofHeaders.push(Output);
        } else {
          return _.map(function(x){
            return Search(x, dept + 1);
          }, elem.children);
        }
      };
      _.map(function(x){
        return Search(x, 0);
      }, doc);
      return listofHeaders;
    };
    CreateHeaderM = function(list){
      var style, nest, RunForEachKid, Recur, Fn, Stuff, topCSS;
      style = {
        "text-decoration": "none",
        "color": "black"
      };
      nest = function(accum, next){
        var CurrentHeight;
        CurrentHeight = _.last(accum).height;
        if (CurrentHeight < next.height) {
          _.last(accum).kid.push(next);
        } else if (CurrentHeight >= next.height) {
          accum.push(next);
        }
        return accum;
      };
      RunForEachKid = function(x){
        return _.fold(nest, [x[0]], _.tail(x));
      };
      Recur = function(x){
        var Second, First;
        Second = function(x){
          if (x.kid.length === 0) {
            return;
          }
          x.kid = RunForEachKid(x.kid);
          return _.each(Second, x.kid);
        };
        First = RunForEachKid(x);
        _.each(Second, First);
        return First;
      };
      Fn = function(x){
        var indent, out;
        indent = {
          "text-decoration": "none",
          "padding": "1%",
          "padding-left": "5%"
        };
        out = [
          m("li", m("a", {
            style: style,
            href: "#" + x.name
          }, x.name)), m("ol", {
            style: indent
          }, _.map(Fn, x.kid))
        ];
        return out;
      };
      _.each(function(x){
        return x.kid = [];
      }, list);
      Stuff = Recur(list);
      topCSS = {
        "left": "-20px",
        "margin-left": "2%"
      };
      return m("ol", {
        style: topCSS
      }, _.map(Fn, Stuff));
    };
    GetHeaders = function(x){
      return _.filter(function(x){
        var test;
        test = /h[2-9]/.exec(x.tag);
        if (test !== null) {
          return true;
        } else {
          return false;
        }
      }, x);
    };
    NinesCompress = function(){
      var WithNum;
      WithNum = _.filter(function(x){
        if (x === 0) {
          return false;
        } else {
          return true;
        }
      }, Nines);
      return _.fold(function(acc, post){
        return acc + "." + post;
      }, "", WithNum);
    };
    EditName = function(elem){
      elem.children[0] = _.tail(NinesCompress() + " " + elem.children[0]);
      return elem;
    };
    FoldFn = function(pre, post){
      var Last, Next;
      Last = parseInt(_.tail(pre.tag)) - 2;
      Next = parseInt(_.tail(post.tag)) - 2;
      if (Next > Last) {
        Nines[Next]++;
        SetValArray(Nines, Next + 1, 0);
      }
      if (Last === Next) {
        Nines[Last]++;
        SetValArray(Nines, Last + 1, 0);
      }
      if (Next < Last) {
        Nines[Next]++;
        SetValArray(Nines, Last, 0);
      }
      EditName(post);
      return post;
    };
    AddReferenceToHead = function(x, name){
      return x.children[0] = m("a", {
        name: name
      }, x.children[0]);
    };
    IndexM = CreateHeaderM(FindHeaders(Mdoc));
    Headers = GetHeaders(Mdoc);
    GetName = function(headers){
      return _.map(function(x){
        return x.children[0];
      }, headers);
    };
    ListOfNames = GetName(Headers);
    _.fold(FoldFn, EditName(_.head(Headers)), _.tail(Headers));
    _.zipWith(AddReferenceToHead, Headers, ListOfNames);
    app.controller = function(){};
    OnMouseClick = function(){
      if (Signals.OpenIndex === false) {
        TM.to(ElementPointers.triangle, 0.5, {
          left: "15%",
          rotation: 180
        });
        TM.to(ElementPointers.doc, 0.5, {
          left: "10%",
          "padding-right": "0%"
        });
        TM.to(ElementPointers.Index, 0.5, {
          left: "0%"
        });
      } else {
        TM.to(ElementPointers.triangle, 0.5, {
          left: 0,
          rotation: 360
        });
        TM.to(ElementPointers.doc, 0.5, {
          left: "0%",
          "padding-right": "10%"
        });
        TM.to(ElementPointers.Index, 0.5, {
          left: "-20%"
        });
      }
      return Signals.OpenIndex = !Signals.OpenIndex;
    };
    FadeInTriangle = function(){
      return TM.to(ElementPointers.triangle, 0.5, {
        "opacity": 0.5
      });
    };
    FadeOutTriangle = function(){
      return TM.to(ElementPointers.triangle, 0.5, {
        "opacity": 0.1
      });
    };
    app.view = function(ctrl){
      var CMUN, media, katex, head, triangleCSS, triangleM, styleMain, styleTextBody, IndexCSS, Index, doc, body, html;
      CMUN = m("link", {
        rel: "stylesheet",
        href: "Serif/cmun-serif.css"
      });
      media = m("link", {
        rel: "stylesheet",
        href: "media.css"
      });
      katex = m("link", {
        rel: "stylesheet",
        href: "katex.min.css"
      });
      head = m("head", [CMUN, media, katex]);
      triangleCSS = {
        width: "0",
        height: "0",
        top: "45%",
        borderTop: "45px solid transparent",
        borderBottom: "45px solid transparent",
        borderLeft: "45px solid rgb(0,0,0)",
        opacity: "0.1",
        position: "fixed",
        zIndex: 100
      };
      triangleM = m("div", {
        style: triangleCSS,
        config: config("triangle"),
        onclick: OnMouseClick,
        onmouseover: FadeInTriangle,
        onmouseleave: FadeOutTriangle
      });
      styleMain = {
        "font-family": "'Computer Modern Serif'"
      };
      styleTextBody = {
        "padding-left": "10%",
        "padding-right": "10%",
        "text-align": "justify",
        "font-size": "15pt",
        "position": "absolute",
        "overflow-y": "auto;"
      };
      IndexCSS = {
        "top": "0",
        "left": "-20%",
        "font-size": "13pt",
        "width": "20%",
        "height": "100%",
        "-webkit-transform": "translateZ(0)",
        "position": "fixed",
        "overflow-y": "scroll",
        "overflow-x": "auto"
      };
      Index = m("div", {
        style: IndexCSS,
        config: config("Index")
      }, IndexM);
      doc = m("div", {
        'class': "Print",
        style: styleTextBody,
        config: config("doc")
      }, [Mdoc]);
      body = m("body", {
        style: {
          fontSize: "8pt"
        },
        config: config("body")
      }, [doc]);
      html = m("html", {
        style: styleMain
      }, [head, triangleM, body, Index]);
      return html;
    };
    return m.module(document, app);
  });
}).call(this);
