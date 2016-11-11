/* SimpleApp.java */
import org.apache.spark.api.java.*;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.function.Function;
import org.apache.spark.api.java.function.Function2;

public class Zero {
  public static void main(String[] args) {
      int blockSize = 64000;
      SparkConf conf = new SparkConf().setAppName("Simple Application");
      JavaSparkContext sc = new JavaSparkContext(conf);

      JavaRDD<byte[]> data = sc.binaryRecords("some.data", blockSize);
      JavaRDD<Integer> newData = data.map(new Function<byte[], Integer>() {
	      public Integer call(byte[] bs) {
		  int total = 0;
		  for(int i = 0; i < bs.length; i++) {
		      if(bs[i] == 0)
			  total++;
		  }
		  return new Integer(total);
	      }
	  });
      Integer res = newData.reduce(new Function2<Integer, Integer, Integer>() {
	      public Integer call(Integer a, Integer b) {
		  return a+b;
	      }
	  });
      System.out.println(res);
  }
}
