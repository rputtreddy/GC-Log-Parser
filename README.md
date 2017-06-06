# GC-Log-Parser

What motivated me to write this automation?
Whenever I used to work on Memory leak issues on Production I have to understand the memory pattern of the application using minimum one week of GC Logs.
With the available existing tools in the market I had a difficulty in keeping the GC graphs in Performance reports that I share to client.
I used to convert the GC Logs to CSV format and used InfluxDB & Grafana to plot graphs.

Objective
1. Extract the required information from the GC logs and save it in CSV format.
2. Trend wise memory pattern analysis will be easier to analyze GC logs after ploting graphs using Grafana.  
3. You can plot the graphs of your own interest

What I am sharing?
1. Perl Script which extracts the required value from GC Logs and save it in CSV format.

Not Sharing?
1. How to load this CSV data into influxDB
2. How to create dashboards using grafana

Current Supported Format:
2017-05-16T16:08:59.142+0530: 22433.171: [GC [PSYoungGen: 692062K->1173K(694272K)] 2048991K->1360606K(2092544K), 0.0298835 secs] [Times: user=0.09 sys=0.00, real=0.03 secs] 
2017-05-16T16:27:02.484+0530: 23516.520: [Full GC [PSYoungGen: 5012K->0K(692736K)] [ParOldGen: 1394679K->378722K(1398272K)] 1399691K->378722K(2091008K) [PSPermGen: 147781K->147238K(524288K)], 1.0404849 secs] [Times: user=3.42 sys=0.00, real=1.05 secs] 

gcParser.pl --> Use this script to convert GC logs into CSV format and later on this can be used to plot the graphs of our own interest.

In future I'll try to add scripts for the remaining formats as well !!

Happy Learning!!
