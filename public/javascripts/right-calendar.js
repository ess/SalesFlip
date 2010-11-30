/**
 * The calendar widget implemented with RightJS
 *
 * Home page: http://rightjs.org/ui/calendar
 *
 * @copyright (C) 2009-2010 Nikolay Nemshilov
 */
var Calendar=RightJS.Calendar=function(u,p,f){function x(a,b,c,e){if(f.Fx)if(c===undefined){c=this.options.fxName;if(e===undefined){e={duration:this.options.fxDuration,onFinish:f(this.fire).bind(this,b)};if(b==="hide")e.duration=(f.Fx.Durations[e.duration]||e.duration)/2}}f.Element.prototype[b].call(a,c,e);if(!f.Fx||!c)this.fire(b);return this}function s(a){return(a<10?"0":"")+a}var o=f,y=f.$,D=f.$$,q=f.$w,E=f.$ext,F=f.isString,z=f.isArray,G=f.isFunction,t=f.Wrapper,l=f.Element,A=f.Input,B=f.RegExp,
C=f.Browser,r=new f.Wrapper(f.Element,{initialize:function(a,b){this.$super("div",b);this._.innerHTML=a;this.addClass("rui-button");this.on("selectstart","stopEvent")},disable:function(){return this.addClass("rui-button-disabled")},enable:function(){return this.removeClass("rui-button-disabled")},disabled:function(){return this.hasClass("rui-button-disabled")},enabled:function(){return!this.disabled()},fire:function(){this.enabled()&&this.$super.apply(this,arguments);return this}}),n=new (function(a,
b){if(!b){b=a;a="DIV"}var c=new f.Wrapper(f.Element.Wrappers[a]||f.Element,{initialize:function(e,d){this.key=e;var g=[{"class":"rui-"+e}];this instanceof f.Input||this instanceof f.Form||g.unshift(a);this.$super.apply(this,g);if(f.isString(d))d=f.$(d);if(d instanceof f.Element){this._=d._;if("$listeners"in d)d.$listeners=d.$listeners;d={}}this.setOptions(d,this);return this},setOptions:function(e,d){d=d||this;f.Options.setOptions.call(this,f.Object.merge(e,eval("("+(d.get("data-"+this.key)||"{}")+
")")));return this}});c=new f.Wrapper(c,b);f.Observer.createShortcuts(c.prototype,c.EVENTS||[]);return c})({include:[{show:function(a,b){this.constructor.current=this;return x.call(this,this,"show",a,b)},hide:function(a,b){this.constructor.current=null;return x.call(this,this,"hide",a,b)},showAt:function(a,b,c){var e=this.hide(null).shownAt=a=f.$(a),d=(this.reAnchor||(this.reAnchor=new f.Element("div",{"class":"rui-re-anchor"})).insert(this)).insertTo(e,"after").position();a=e.dimensions();var g=
p(e.getStyle("borderTopWidth")),h=p(e.getStyle("borderLeftWidth")),j=p(e.getStyle("borderRightWidth")),i=p(e.getStyle("borderBottomWidth"));e=a.top-d.y+g;d=a.left-d.x+h;h=a.width-h-j;a=a.height-g-i;this.setStyle("visibility:hidden").show(null);if(b==="right")d+=h-this.size().x;else e+=a;this.moveTo(d,e);if(c)["left","right"].include(b)?this.setHeight(a):this.setWidth(h);this.setStyle("visibility:visible").hide(null);return this.show()},toggleAt:function(a,b,c){return this.hidden()?this.showAt(a,b,
c):this.hide()}},{assignTo:function(a,b){a=f.$(a);if(b=f.$(b)){b[this.key]=this;b.assignedInput=a}else a[this.key]=this;var c=f(function(){if(this.visible()&&(!this.showAt||this.shownAt===a))this.setValue(a.value())}).bind(this);a.on({keyup:c,change:c});this.onChange(function(){if(!this.showAt||this.shownAt===a)a.setValue(this.getValue())});return this}}],extend:{version:"2.0.0",EVENTS:q("show hide change done"),Options:{format:"ISO",showTime:null,showButtons:false,minDate:false,maxDate:false,fxName:"fade",
fxDuration:"short",firstDay:1,numberOfMonths:1,timePeriod:1,twentyFourHour:null,listYears:false,hideOnPick:false,update:null,trigger:null,cssRule:"*[data-calendar]"},Formats:{ISO:"%Y-%m-%d",POSIX:"%Y/%m/%d",EUR:"%d-%m-%Y",US:"%m/%d/%Y"},i18n:{Done:"Done",Now:"Now",NextMonth:"Next Month",PrevMonth:"Previous Month",NextYear:"Next Year",PrevYear:"Previous Year",dayNames:q("Sunday Monday Tuesday Wednesday Thursday Friday Saturday"),dayNamesShort:q("Sun Mon Tue Wed Thu Fri Sat"),dayNamesMin:q("Su Mo Tu We Th Fr Sa"),
monthNames:q("January February March April May June July August September October November December"),monthNamesShort:q("Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec")},current:null,hideAll:function(a){D("div.rui-calendar").each(function(b){b instanceof n&&b!==a&&b.visible()&&!b.inlined()&&b.hide()})}},initialize:function(a){this.$super("calendar",a);this.addClass("rui-panel");a=this.options;this.insert([this.swaps=new H(a),this.greed=new I(a)]);if(a.showTime)this.insert(this.timepicker=new J(a));
if(a.showButtons)this.insert(this.buttons=new K(a));this.setDate(new Date).initEvents()},setDate:function(a,b){if(a=this.parse(a)){var c=this.options;if(c.minDate&&c.minDate>a)a=new Date(c.minDate);if(c.maxDate&&c.maxDate<a){a=new Date(c.maxDate);a.setDate(a.getDate()-1)}this._date=b?new Date(this._date||this.date):null;this.greed.setDate(this._date||a,a);if(c.minDate||c.maxDate)this.swaps.setDate(a);this.timepicker&&!b&&this.timepicker.setDate(a);if(a!=this.date)this.fire("change",{date:this.date=
a})}return this},getDate:function(){return this.date},setValue:function(a){return this.setDate(a)},getValue:function(a){return this.format(a)},insertTo:function(a,b){this.addClass("rui-calendar-inline");return this.$super(a,b)},done:function(){this.inlined()||this.hide();this.fire("done",{date:this.date})},inlined:function(){return this.hasClass("rui-calendar-inline")},setOptions:function(a){a=a||{};this.$super(a,y(a.trigger||a.update));var b=this.constructor,c=this.options;c.i18n={};for(var e in b.i18n)c.i18n[e]=
z(b.i18n[e])?b.i18n[e].clone():b.i18n[e];E(c.i18n,a.i18n);c.dayNames=c.i18n.dayNamesMin;c.firstDay&&c.dayNames.push(c.dayNames.shift());if(!z(c.numberOfMonths))c.numberOfMonths=[c.numberOfMonths,1];if(c.minDate)c.minDate=this.parse(c.minDate);if(c.maxDate){c.maxDate=this.parse(c.maxDate);c.maxDate.setDate(c.maxDate.getDate()+1)}c.format=o(b.Formats[c.format]||c.format).trim();if(c.showTime===null)c.showTime=c.format.search(/%[HkIl]/)>-1;if(c.twentyFourHour===null)c.twentyFourHour=c.format.search(/%[Il]/)<
0;if(c.timePeriod>60&&12%Math.ceil(c.timePeriod/60))c.twentyFourHour=true;c.update&&this.assignTo(c.update,c.trigger);return this},hideOthers:function(){n.hideAll(this);return this}}),H=new t(l,{initialize:function(a){this.$super("div",{"class":"swaps"});this.options=a;var b=a.i18n;this.insert([this.prevMonth=new r("&lsaquo;",{title:b.PrevMonth,"class":"prev-month"}),this.nextMonth=new r("&rsaquo;",{title:b.NextMonth,"class":"next-month"})]);if(a.listYears)this.insert([this.prevYear=new r("&laquo;",
{title:b.PrevYear,"class":"prev-year"}),this.nextYear=new r("&raquo;",{title:b.NextYear,"class":"next-year"})]);this.buttons=o([this.prevMonth,this.nextMonth,this.prevYear,this.nextYear]).compact();this.onClick(this.clicked)},setDate:function(a){var b=this.options,c=b.numberOfMonths[0]*b.numberOfMonths[1],e=true,d=true,g=true,h=true;if(b.minDate){g=new Date(a.getFullYear(),0,1,0,0,0);var j=new Date(b.minDate.getFullYear(),0,1,0,0,0);e=g>j;g.setMonth(a.getMonth()-Math.ceil(c-c/2));j.setMonth(b.minDate.getMonth());
g=g>=j}if(b.maxDate){a=new Date(a);b=new Date(b.maxDate);c=o([a,b]);c.each(function(i){i.setDate(32);i.setMonth(i.getMonth()-1);i.setDate(32-i.getDate());i.setHours(0);i.setMinutes(0);i.setSeconds(0);i.setMilliseconds(0)});h=a<b;c.each("setMonth",0);d=a<b}this.nextMonth[h?"enable":"disable"]();this.prevMonth[g?"enable":"disable"]();if(this.nextYear){this.nextYear[d?"enable":"disable"]();this.prevYear[e?"enable":"disable"]()}},clicked:function(a){(a=a.target)&&this.buttons.include(a)&&a.enabled()&&
this.fire(a.get("className").split(/\s+/)[0])}}),L=new t(l,{initialize:function(a){this.$super("table",{"class":"month"});this.options=a;this.insert(this.caption=new l("caption"));this.insert("<thead><tr>"+a.dayNames.map(function(d){return"<th>"+d+"</th>"}).join("")+"</tr></thead>");this.days=[];a=(new l("tbody")).insertTo(this);var b,c,e;for(c=0;c<6;c++){e=(new l("tr")).insertTo(a);for(b=0;b<7;b++)this.days.push((new l("td")).insertTo(e))}this.onClick(this.clicked)},setDate:function(a,b){a.setDate(32);
var c=32-a.getDate();a.setMonth(a.getMonth()-1);for(var e=Math.ceil(b.getTime()/864E5),d=this.options,g=d.i18n,h=this.days,j=0,i=h.length-1,k,m,v;j<7;j++){k=h[j]._;m=h[i-j]._;v=h[i-j-7]._;k.innerHTML=m.innerHTML=v.innerHTML="";k.className=m.className=v.className="blank"}j=1;i=0;for(var w;j<=c;j++){a.setDate(j);m=a.getDay();if(d.firstDay===1)m=m>0?m-1:6;if(j===1||m===0){w=h.slice(i*7,i*7+7);i++}k=w[m]._;if(C.OLD){k.innerHTML="";k.appendChild(u.createTextNode(j))}else k.innerHTML=""+j;k.className=e===
Math.ceil(a.getTime()/864E5)?"selected":"";if(d.minDate&&d.minDate>a||d.maxDate&&d.maxDate<a)k.className="disabled";w[m].date=new Date(a)}c=(d.listYears?g.monthNamesShort[a.getMonth()]+",":g.monthNames[a.getMonth()])+" "+a.getFullYear();e=this.caption._;if(C.OLD){e.innerHTML="";e.appendChild(u.createTextNode(c))}else e.innerHTML=c},clicked:function(a){a=a.target;var b=a.date;if(a&&b&&!a.hasClass("disabled")&&!a.hasClass("blank")){a.addClass("selected");this.fire("date-set",{date:b.getDate(),month:b.getMonth(),
year:b.getFullYear()})}}}),I=new t(l,{initialize:function(a){this.$super("table",{"class":"greed"});this.months=[];for(var b=(new l("tbody")).insertTo(this),c,e=0;e<a.numberOfMonths[1];e++)for(var d=(new l("tr")).insertTo(b),g=0;g<a.numberOfMonths[0];g++){this.months.push(c=new L(a));(new l("td")).insertTo(d).insert(c)}},setDate:function(a,b){var c=this.months,e=c.length;b=b||a;for(var d=-Math.ceil(e-e/2)+1,g=0;d<Math.floor(e-e/2)+1;d++,g++){var h=new Date(a);h.setMonth(a.getMonth()+d);c[g].setDate(h,
b)}}}),J=new t(l,{initialize:function(a){this.$super("div",{"class":"timepicker"});this.options=a;var b=o(this.timeChanged).bind(this);this.insert([this.hours=(new l("select")).onChange(b),this.minutes=(new l("select")).onChange(b)]);for(var c=a.timePeriod<60?a.timePeriod:60,e=a.timePeriod<60?1:Math.ceil(a.timePeriod/60),d=0;d<60;d++){var g=s(d);if(d<24&&d%e==0)if(a.twentyFourHour)this.hours.insert(new l("option",{value:d,html:g}));else if(d<12)this.hours.insert(new l("option",{value:d,html:d==0?
12:d}));d%c==0&&this.minutes.insert(new l("option",{value:d,html:g}))}if(!a.twentyFourHour){this.meridian=(new l("select")).onChange(b).insertTo(this);o(o(a.format).includes(/%P/)?["am","pm"]:["AM","PM"]).each(function(h){this.meridian.insert(new l("option",{value:h.toLowerCase(),html:h}))},this)}},setDate:function(a){var b=this.options,c=b.timePeriod<60?a.getHours():Math.round(a.getHours()/(b.timePeriod/60))*(b.timePeriod/60);a=Math.round(a.getMinutes()/(b.timePeriod%60))*b.timePeriod;if(this.meridian){this.meridian.setValue(c<
12?"am":"pm");c=c==0||c==12?12:c>12?c-12:c}this.hours.setValue(c);this.minutes.setValue(a)},timeChanged:function(a){a.stopPropagation();a=p(this.hours.value());var b=p(this.minutes.value());if(this.meridian){if(a==12)a=0;if(this.meridian.value()=="pm")a+=12}this.fire("time-set",{hours:a,minutes:b})}}),K=new t(l,{initialize:function(a){this.$super("div",{"class":"buttons"});this.insert([(new r(a.i18n.Now,{"class":"now"})).onClick("fire","now-clicked"),(new r(a.i18n.Done,{"class":"done"})).onClick("fire",
"done-clicked")])}});n.include({parse:function(a){var b;if(F(a)&&a){var c=B.escape(this.options.format),e=o(c.match(/%[a-z]/ig)).map("match",/[a-z]$/i).map("first").without("%");c=new B("^"+c.replace(/%p/i,"(pm|PM|am|AM)").replace(/(%[a-z])/ig,"(.+?)")+"$");if(a=o(a).trim().match(c)){a.shift();for(var d=c=null,g=null,h=null,j=null,i;a.length;){var k=a.shift(),m=e.shift();if(m.toLowerCase()=="b")d=this.options.i18n[m=="b"?"monthNamesShort":"monthNames"].indexOf(k);else if(m.toLowerCase()=="p")i=k.toLowerCase();
else{k=p(k,10);switch(m){case "d":case "e":b=k;break;case "m":d=k-1;break;case "y":case "Y":c=k;break;case "H":case "k":case "I":case "l":g=k;break;case "M":h=k;break;case "S":j=k;break}}}if(i){g=g==12?0:g;g=i=="pm"?g+12:g}b=new Date(c,d,b,g,h,j)}}else if(a instanceof Date||Date.parse(a))b=new Date(a);return!b||isNaN(b.getTime())?null:b},format:function(a){var b=this.options.i18n,c=this.date.getDay(),e=this.date.getMonth(),d=this.date.getDate(),g=this.date.getFullYear(),h=this.date.getHours(),j=this.date.getMinutes(),
i=this.date.getSeconds(),k=h==0?12:h<13?h:h-12;b={a:b.dayNamesShort[c],A:b.dayNames[c],b:b.monthNamesShort[e],B:b.monthNames[e],d:s(d),e:""+d,m:(e<9?"0":"")+(e+1),y:(""+g).substring(2,4),Y:""+g,H:s(h),k:""+h,I:(h>0&&(h<10||h>12&&h<22)?"0":"")+k,l:""+k,p:h<12?"AM":"PM",P:h<12?"am":"pm",M:s(j),S:s(i),"%":"%"};a=a||this.options.format;for(var m in b)a=a.replace("%"+m,b[m]);return a}});n.include({initEvents:function(){var a=this._terminate;this.on({"prev-day":["_shiftDate",{Date:-1}],"next-day":["_shiftDate",
{Date:1}],"prev-week":["_shiftDate",{Date:-7}],"next-week":["_shiftDate",{Date:7}],"prev-month":["_shiftDate",{Month:-1}],"next-month":["_shiftDate",{Month:1}],"prev-year":["_shiftDate",{FullYear:-1}],"next-year":["_shiftDate",{FullYear:1}],"date-set":this._changeDate,"time-set":this._changeTime,"now-clicked":this._setNow,"done-clicked":this.done,click:a,mousedown:a,focus:a,blur:a})},_shiftDate:function(a){var b=new Date(this.date);for(var c in a)b["set"+c](b["get"+c]()+a[c]);this.setDate(b)},_changeDate:function(a){var b=
new Date(this.date);b.setDate(a.date);b.setMonth(a.month);b.setFullYear(a.year);this.setDate(b,true);this.options.hideOnPick&&this.done()},_changeTime:function(a){var b=new Date(this.date);b.setHours(a.hours);b.setMinutes(a.minutes);this.setDate(b)},_setNow:function(){this.setDate(new Date)},_terminate:function(a){a.stopPropagation();if(this._hide_delay){this._hide_delay.cancel();this._hide_delay=null}}});y(u).on({focus:function(a){a=a.target instanceof A&&a.target.get("type")=="text"?a.target:null;
n.hideAll();if(a&&(a.calendar||a.match(n.Options.cssRule)))(a.calendar||new n({update:a})).setValue(a.value()).showAt(a)},blur:function(a){var b=a.target.calendar;if(b)b._hide_delay=o(function(){b.hide()}).delay(200)},click:function(a){var b=a.target instanceof l?a.target:null;if(b&&(b.calendar||b.match(n.Options.cssRule))){if(!(b instanceof A)||b.get("type")!="text"){a.stop();(b.calendar||new n({trigger:b})).hide(null).toggleAt(b.assignedInput)}}else a.find("div.rui-calendar")||n.hideAll()},keydown:function(a){var b=
n.current,c={27:"hide",37:"prev-day",39:"next-day",38:"prev-week",40:"next-week",33:"prev-month",34:"next-month",13:"done"}[a.keyCode];if(c&&b&&b.visible()){a.stop();G(b[c])?b[c]():b.fire(c)}}});u.write('<style type="text/css">.rui-panel{margin:0;padding:.5em;position:relative;background-color:#EEE;border:1px solid #BBB;border-radius:.3em;-moz-border-radius:.3em;-webkit-border-radius:.3em;box-shadow:.15em .3em .5em #BBB;-moz-box-shadow:.15em .3em .5em #BBB;-webkit-box-shadow:.15em .3em .5em #BBB;cursor:default} *.rui-button{display:inline-block; *display:inline; *zoom:1;height:1em;line-height:1em;margin:0;padding:.2em .5em;text-align:center;border:1px solid #CCC;border-radius:.2em;-moz-border-radius:.2em;-webkit-border-radius:.2em;cursor:pointer;color:#333;background-color:#FFF;user-select:none;-moz-user-select:none;-webkit-user-select:none} *.rui-button:hover{color:#111;border-color:#999;background-color:#DDD;box-shadow:#888 0 0 .1em;-moz-box-shadow:#888 0 0 .1em;-webkit-box-shadow:#888 0 0 .1em} *.rui-button:active{color:#000;border-color:#777;text-indent:1px;box-shadow:none;-moz-box-shadow:none;-webkit-box-shadow:none} *.rui-button-disabled, *.rui-button-disabled:hover, *.rui-button-disabled:active{color:#888;background:#DDD;border-color:#CCC;cursor:default;text-indent:0;box-shadow:none;-moz-box-shadow:none;-webkit-box-shadow:none}div.rui-re-anchor{margin:0;padding:0;background:none;border:none;float:none;display:inline;position:absolute;z-index:9999}div.rui-calendar .swaps,div.rui-calendar .greed,div.rui-calendar .timepicker,div.rui-calendar .buttons,div.rui-calendar table,div.rui-calendar table tr,div.rui-calendar table th,div.rui-calendar table td,div.rui-calendar table tbody,div.rui-calendar table thead,div.rui-calendar table caption{background:none;border:none;width:auto;height:auto;margin:0;padding:0}div.rui-calendar-inline{position:relative;display:inline-block; *display:inline; *zoom:1;box-shadow:none;-moz-box-shadow:none;-webkit-box-shadow:none}div.rui-calendar .swaps{position:relative}div.rui-calendar .swaps .rui-button{position:absolute;float:left;width:1em;padding:.15em .4em}div.rui-calendar .swaps .next-month{right:0em;_right:.5em}div.rui-calendar .swaps .prev-year{left:2.05em}div.rui-calendar .swaps .next-year{right:2.05em;_right:2.52em}div.rui-calendar .greed{border-spacing:0px;border-collapse:collapse;border-size:0}div.rui-calendar .greed td{vertical-align:top;padding-left:.4em}div.rui-calendar .greed>tbody>tr>td:first-child{padding:0}div.rui-calendar .month{margin-top:.2em;border-spacing:1px;border-collapse:separate}div.rui-calendar .month caption{text-align:center}div.rui-calendar .month th{color:#666;text-align:center}div.rui-calendar .month td{text-align:right;padding:.1em .3em;background-color:#FFF;border:1px solid #CCC;cursor:pointer;color:#555;border-radius:.2em;-moz-border-radius:.2em;-webkit-border-radius:.2em}div.rui-calendar .month td:hover{background-color:#CCC;border-color:#AAA;color:#000}div.rui-calendar .month td.blank{background:transparent;cursor:default;border:none}div.rui-calendar .month td.selected{background-color:#BBB;border-color:#AAA;color:#222;font-weight:bold;padding:.1em .2em}div.rui-calendar .month td.disabled{color:#888;background:#EEE;border-color:#CCC;cursor:default}div.rui-calendar .timepicker{border-top:1px solid #ccc;margin-top:.3em;padding-top:.5em;text-align:center}div.rui-calendar .timepicker select{margin:0 .4em}div.rui-calendar .buttons{position:relative;margin-top:.5em}div.rui-calendar .buttons div.rui-button{width:4em;padding:.25em .5em}div.rui-calendar .buttons .done{position:absolute;right:0em;top:0}</style>');
return n}(document,parseInt,RightJS);
