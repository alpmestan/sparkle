import java.util.ArrayList;
import java.util.List;
import org.apache.spark.api.java.*;
import org.apache.spark.SparkConf;
import org.apache.spark.api.java.function.Function;

public class Micro {
  public static void main(String[] args) {
      Integer n = Integer.parseInt(args[0]);
      Integer nbPartitions = Integer.parseInt(args[1]);

      SparkConf conf = new SparkConf().setAppName("Micro Benchmark");
      JavaSparkContext sc = new JavaSparkContext(conf);

      ArrayList<Integer> arr = new ArrayList();
      for(Integer i = 0; i < n; i++)
	  arr.add(i);

      JavaRDD<Integer> data = sc.parallelize(arr).repartition(nbPartitions);
      JavaRDD<Integer> newData = data.map(new Function<Integer, Integer>() {
	      public Integer call(Integer i) {
		  return i+1;
	      }
	  });
      List<Integer> res = newData.collect();
      System.out.println("Result: " + res.get(0));
  }
}
