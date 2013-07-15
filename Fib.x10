import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
import x10.lang.*;
public class Fib {
    var n:Int = 0;
    
    def this( n:Int ){ this.n = n; }

    def fib()
    {
        if( n <= 2 )
        {
            n = 1;
            return;
        }
        val f1 = new Fib( n - 1 );
        val f2 = new Fib( n - 2 );
        finish{

            async f1.fib();

            f2.fib();
        }
        n = f1.n + f2.n;
    }

    public  static def  main(args: Array[String]) 
    {

        val timer = new Timer();
        var startTime:Long = timer.nanoTime();

        if( args.size < 1 )
        {
            Console.OUT.println(" Usage: Fib <n>");
            return;
        }
        val n = Int.parse(args(0));
        val f = new Fib(n);
        f.fib();
        Console.OUT.println(" fib(" + n + ") = " + f.n);

        var endTime:Long = timer.nanoTime();
        Console.OUT.println( "It used " + ( endTime - startTime ) + "ns" );
    }
}
