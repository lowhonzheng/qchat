\d .plot

/ gnuplot wrapper, plot graph & return
gplt:{[c;i] /c:commands,i:input
  @[system"echo '",sv[`;csv 0:i],"' | gnuplot -e \"",sv[";";c],"\"";0;1_]
 }

/ download csv from Google finance for sym
dcsv:{[s] /s:sym
  a:.Q.hg `$":http://finance.google.com/finance/historical?output=csv&q=",string[s];
  if[0<count ss[a;"Error 400"];:()];
  ("DFFFFI";enlist ",")0: 3_a
 }

/ gnuplot program
c:("set terminal dumb";
   "set datafile separator ','";
   "set xdata time";
   "set timefmt '%Y-%m-%d'";
   "set key off";
   "plot '-' using 1:5 with lines")

/ plot close prices for given sym, make red
plt:{[c;s] /c:gnuplot commands,s:sym
  if[()~t:dcsv s;:()];
  ssr[;"*";"\033[31m*\033[0m"] ` sv gplt[c] 31#t
 }[c]

/ stock plot
.plot.getplot:{[u;s;h] /u:user,s:sym,h:user handle
  if[()~p:.plot.plt s;:neg[.z.w](`stkerr;h)];
  :neg[.z.w](`worker;`stock;"Hey ",u,", plot for ",string[s]," over last month:",p)
 }

\d .
