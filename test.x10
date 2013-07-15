import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
import x10.lang.*;
public class test {
	public  def sum( i:Int, j:Int )
	{
		return i+j;
	}
    public  static def  main(args: Array[String]) 
    {

    	var s:Array[Int] = new Array[Int](10, (Int)=>0);
    	
    	for( [i,j] in (0..s.size)*(0..s.size))
    	{
    		Console.OUT.println(i+j);
    	}
    	Console.OUT.println("---------------------------------------------------------");

    	var t:test = new test();
    	Console.OUT.println("5 + 10 = " + t.sum( 5, 10 ));

    	Console.OUT.println("---------------------------------------------------------");

        val timer = new Timer();
        var startTime:Long = timer.nanoTime();
        finish {
            for ( i in 0..s.size )
            {

                async Console.OUT.println( i );
            }
        }
        var endTime:Long = timer.nanoTime();
        Console.OUT.println( "It used " + ( endTime - startTime ) + "ns" );
        Console.OUT.println("---------------------------------------------------------");

        var r:Rail[Int] = new Rail[Int]( 10, (Int)=>2 );
        for( i in 0..9)
            Console.OUT.println(" Get Rail i th item: " +"Rail[" + i + "] = " + r(i));

        Console.OUT.println("---------------------------------------------------------");
    }
}
