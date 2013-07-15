import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
import x10.lang.*;
public class ComDetect_n {
	
	var fileName:String;
	var MaxNode:Int;
	var edgeNum:Int;
	val g:Graph_undirect;
	var moves:Int = 0; //input move times

	public def this(){
		fileName:String = "../../Data/BlondelMethod/arxiv.txt";
		MaxNode:Int = 9376;
		edgeNum:Int = 48214;
		g = new Graph_undirect(fileName,0,MaxNode,edgeNum);
	}
	public def this(var file:String, var node:Int, var edge:Int)
	{
		fileName:String = file;
		MaxNode:Int = node;
		edgeNum:Int = edge;
		g = new Graph_undirect(fileName,0,MaxNode,edgeNum);
	}
	public static def one_pass(var id:Int, var startIndex:Int, var endIndex:Int, var args:Array[String], var ComDe:ComDetect_n, var indexs:Array[Int],var com:Comcal_opt,var total_weight:Double){
		
		var endId:Int = 0;
		var frontID:Int = 0;
		var Kitoin:Double = 0.0;
		var gain:Double = 0.0;
        var maxId:Int;
        var maxGain:Double;
        var totWeight:Double;
        var nodeWeight:Double;  //Ki
        var insideWeight:Double;        
        var newComId:Int;
        var hash_newCom:HashSet[Int];
        var moves:Int = 0;  
        
       
        var isR:boolean = false;
        if(args.size != 0 && args(0).equals("-r") )
        {
        	Console.OUT.println("Compute randomly");
        	isR = true;
        }
      
		//compute 
		var endNodeList:ArrayList[Pair[Int,Double]];
		for( var i:Int = startIndex; i < endIndex; i++ ){
			
			if(isR)
			{
				frontID = indexs(i);
			}
			else
				frontID = i;
		 	
			endNodeList = ComDe.g.links(frontID).getEndNodeList();
			
			//if(endNodeList.size() == 0)  continue;
		   if(endNodeList.size() == 1){
				endId = 0;
				endId = endNodeList(0).first;
				gain = 0.0;
				if ( endId < endIndex && endId > startIndex )
				{

				newComId = ComDe.g.node2com(endId);
				hash_newCom = ComDe.g.com(newComId).getNodeList();        
				
				com.setKitoIn(endNodeList,hash_newCom/*,newComId*/);
				Kitoin = com.plusInsideWeight;
				
				nodeWeight = ComDe.g.links(frontID).nodeWeight;
				totWeight = ComDe.g.com(ComDe.g.node2com(endId)).getTot();
				
				gain = com.getGain(total_weight,nodeWeight,totWeight,Kitoin);
				if(gain > 0 && ComDe.g.node2com(i)!= ComDe.g.node2com(endId))
				{
					moves = moves + 1;
				}				
				if(gain > 0)
				{					
					 atomic com.addNode(ComDe, /*links_opt(frontID).getCheckList(),*/ComDe.g.links(frontID).getNodeWeight(),frontID,endId/*,links_opt(frontID).getNodeComWeightList()*/, ComDe.g.links(frontID).getEndNodeList() );
				}	

				}			
				
			}
			else if(endNodeList.size()>1){		
				Kitoin = 0.0;
				maxId = -1;
				maxGain = -1.0;
				gain = 0.0;
				for(var k:Int = 0;k<endNodeList.size();k++)
				{
					
					endId = 0;
					totWeight = 0.0;
					nodeWeight = 0.0;  //Ki
					insideWeight = 0.0; 
					Kitoin = 0.0;
					
					endId = endNodeList(k).first;	
					if( endId < endIndex && endId > startIndex )
					{


					var vbWeight:Box[Double] = ComDe.g.links(frontID).getNodeComWeightList().get(endId);
					if(vbWeight!=null)
						Kitoin=vbWeight.value;
						else Kitoin=0.0;						
						nodeWeight = ComDe.g.links(frontID).nodeWeight;
						totWeight = ComDe.g.com(ComDe.g.node2com(endId)).getTot();
						insideWeight = ComDe.g.com(ComDe.g.node2com(endId)).getIn(); 
						gain = com.getGain(total_weight,nodeWeight,totWeight,Kitoin);
						
						if(gain > 0 && gain > maxGain)
						{
							maxGain = gain;
							maxId = endId;	
						}
					}
					
				}
				if(maxGain>0 && maxId != -1 && ComDe.g.node2com(i)!= ComDe.g.node2com(maxId))
					{
						moves = moves + 1;
					}
				if(maxGain>0 && maxId != -1)
				{
						atomic com.addNode(ComDe, /*links_opt(frontID).getCheckList(),*/ ComDe.g.links(frontID).getNodeWeight(), frontID, maxId, /*links_opt(frontID).getNodeComWeightList(),*/ ComDe.g.links(frontID).getEndNodeList() );		
				}
				maxId = -1;


			}
			
		}//end for
		
		//Console.OUT.println("moves = " + ComDe.moves);
		//return ComDe.moves;
		Console.OUT.println("threadId = " + id + ", moves = " + moves);
		ComDe.moves = ComDe.moves + moves;
		
	}
	public static def display_com(var comInfo_obj:Array[Community])
	{
		//Console.OUT.println("comInfo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
		var sum:Double = 0.0;
		var nodeSize:Int = 0;
		for(var i:Int=0;i<comInfo_obj.size;i++)
		{
			var list:HashSet[Int];
			list=comInfo_obj(i).getNodeList();
			
			
			Console.OUT.print("comNum::::"+i+"::::");
			var it:Iterator[Int]=list.iterator();
			while(it.hasNext()){
				Console.OUT.print(","+it.next());
			}
			Console.OUT.println();
			
			//Console.OUT.println("node_hash size: " + comInfo_obj(i).node_hash.size());
			
			Console.OUT.println("comTot---comIn");
			Console.OUT.println(comInfo_obj(i).getTot() + " - " + comInfo_obj(i).getIn());
			 
			if( comInfo_obj(i).node_hash.size()!=0 )
			{
				nodeSize = comInfo_obj(i).node_hash.size() + nodeSize;
				sum = sum + comInfo_obj(i).getTot()  ;
			}
		}
		Console.OUT.println("total weight, nodeSize: " + sum + ", " + nodeSize );
	}
	public static def display_sum(var comInfo_obj:Array[Community])
	{
		//Console.OUT.println("comInfo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
		var sum:Double = 0.0;
		var nodeSize:Int = 0;
		for(var i:Int=0;i<comInfo_obj.size;i++)
		{		
			if( comInfo_obj(i).node_hash.size()!=0 )
			{
				nodeSize = comInfo_obj(i).node_hash.size() + nodeSize;
				sum = sum + comInfo_obj(i).getTot() + comInfo_obj(i).getIn() ;
			}
		}
		Console.OUT.println("total weight, nodeSize: " + sum + ", " + nodeSize );
		return sum;
	}
	public static def display(var links_opt:Array[Links_opt],var node2com:Array[Int],var comInfo_obj:Array[Community]){
		
		Console.OUT.println("Links:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
		for(var i:Int=0;i<links_opt.size;i++)
		{
		    var endNodeList:ArrayList[Pair[Int,Double]];
		    endNodeList=links_opt(i).getEndNodeList();
		    Console.OUT.println("node"+i+"::endNodeList-------------------------------------------------");
		    for(var j:Int=0;j<endNodeList.size();j++){
		    	Console.OUT.println("start-end-weight::"+i+"-"+endNodeList(j).first+"-"+endNodeList(j).second);
		    }
		    var linkList:HashMap[Int,Double];
		    linkList = links_opt(i).getNodeComWeightList();
		    val it1 = linkList.entries().iterator();
	        Console.OUT.println("node"+i+"::comWeightList-------------------------------------------------");
		    while(it1.hasNext())
		    {
		    	var me:Map.Entry[Int,Double] = it1.next();
                Console.OUT.println("start-com-weight:::"+i+"-"+me.getKey()+"-"+me.getValue());
		    }
		}
		
		Console.OUT.println("node2com:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");		
		for(var i:Int=0;i<node2com.size;i++)
		{
			Console.OUT.println("nodeId-comId:::"+i+"-"+node2com(i));
		}
		
		Console.OUT.println("comInfo:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::");
		for(var i:Int=0;i<comInfo_obj.size;i++)
		{
		  var list:HashSet[Int];
		  list=comInfo_obj(i).getNodeList();
		  Console.OUT.println("nodeComList--------------------------------------------------------");
		  Console.OUT.println("comNum::::"+i);
		  var it:Iterator[Int]=list.iterator();
		  while(it.hasNext()){
			  Console.OUT.print(","+it.next());
		  }
		  Console.OUT.println();
		  Console.OUT.println("comTot---comIn::::::::::::::");
		  Console.OUT.println(comInfo_obj(i).getTot()+"-"+comInfo_obj(i).getIn());
		}
		
	}
    public  static def  main(args: Array[String]) {
    	val timer = new Timer();
    	var start:Long = timer.milliTime();
  
    	Console.OUT.println("args:" + args);
    	
    	var readEndTime:Long = timer.milliTime();
    	var outputStart:Long = 0;
    	
    	var com:Comcal_opt = new Comcal_opt();
    	var comDe:ComDetect_n;

    	var threadNums:Int = 0;
    	var threadId:Int =0;

    	if( args.size < 6 ) Console.OUT.println( "Not enough num Parameters! " );
    	if( args.size>=6 )
    	{
    		comDe = new ComDetect_n(args(2), Int.parse(args(3)), Int.parse(args(4)));
    		threadNums = Int.parse(args(5));
    	}
    	else 
    		comDe = new ComDetect_n();
    	var ifCircle:boolean = true;
    	var circleNum:Int = 1;
        var clusterNum:Int = 0;
        var clusterNumPre:Int = -1;
        
        var indexs:Array[Int];
        indexs = new Array[Int]( comDe.MaxNode + 1 );
        
        var r:Random = new Random();
		var tmp:Int = 0;
		for(var i:Int = 0; i < comDe.MaxNode + 1;i++)
		{
			indexs(i) = i;
		}
        for(var i:Int = 0; i < comDe.MaxNode + 1;i++)
        {
        	tmp = r.nextInt( comDe.MaxNode + 1 );
        	indexs(i) = tmp;
        	indexs(tmp) = i;
        }
        
        var total_weight:Double = comDe.g.total_weight;;

        var level:Int = 0;

        var math:Math = new Math();
        
        var totalComputeTime:Double = 0.0;
        var mod:Double = 0.0;
        var preMod:Double = 0.0;
        var preLevelMod:Double = 0.0;
        var preLevelClusterNum:Int = 0;

        com.setModularity(total_weight,comDe.g.com);
        preMod = com.getModularity();
        
        Console.OUT.println("---------------------------");
        Console.OUT.println("In Level: "+level);

        //var moves:Int = 0;
        
        //preMod = mod;
        var isOne:boolean = false;
        
    	while(ifCircle)
    	{

    		Console.OUT.println("preMod->mod:"+preMod+"->"+mod);
    		
    		Console.OUT.println(isOne);

    		if ( clusterNumPre == clusterNum || mod < preMod || ( mod - preMod > 0 && mod - preMod < 0.0001 ) || isOne  ) 
    		{
    			
    			preLevelMod = mod;
    			preLevelClusterNum = clusterNum;
    			
    			Console.OUT.println("Get into reset part!!");
    			
    			comDe.g.resetGraph(comDe, clusterNum);
    			
    			comDe.g.links = new Array[Links_opt](clusterNum);
    			comDe.g.node2com = new Array[Int] (clusterNum);
    			comDe.g.com = new Array[Community](clusterNum);
    			comDe.g.nodeIn = new Array[Double](clusterNum);

    			comDe.g.links = comDe.g.links_n;
    			comDe.g.node2com = comDe.g.node2com_n;
    			comDe.g.nodeIn = comDe.g.nodeIn_n;
    			comDe.g.com = comDe.g.com_n;
	      		indexs = new Array[Int]( clusterNum );
			    tmp = 0;		
			    for(var i:Int = 0; i < clusterNum; i++)
			    {
			    	indexs(i) = i;
			    }
    		    for( var i:Int = 0; i < clusterNum; i++ )
    		    {
    		    	tmp = r.nextInt( clusterNum );
    			    indexs(i) = tmp;
    			    indexs(tmp) = i;
    			}
    			
    			level = level + 1;
    			Console.OUT.println("---------------------------");
    			Console.OUT.println("In Level: "+level);
    			circleNum = 1;
    			comDe.moves = 0;			
    		}
    		
    	// Console.OUT.print("before::");
    		comDe.display_sum(comDe.g.com);	
         //display(links_opt,node2com,comInfo_obj);
    		
    	    preMod = mod;
    	    clusterNumPre = clusterNum;
    	    clusterNum = 0;        
    	    var startCompute:Long = timer.milliTime();

    	    var band:Int = comDe.g.links.nodeSize / threadNums;
    	    finish 
    	    {    
            	for ( threadId = 0; threadId < threadNums; threadId++ ){
                	val startIndex:Int=threadId*band;
                	val id:Int = threadId;
                	val endIndex:Int=(threadId+1)*band;
                	async 
                	{
                		if( id == (threadNums-1) )
                		{
							var links_sub:Array[Links_opt] = new Array[Links_opt]((endIndex - startIndex));
        					var node2com_sub:Array[Int] = new Array[Int]((endIndex - startIndex));
        					var nodeIn_sub:Array[Double] = new Array[Double]((endIndex - startIndex));
        					var com_sub:Array[Community] = new Array[Community]((endIndex - startIndex));
        					for (var i:Int = 0; i < links_sub.size; i++ )
        					{
        						links_sub( i ) = comDe.g.links(startIndex);
        						//links = comDe.g.links_n;
    							node2com_sub = comDe.g.node2com_n(startIndex);
    							nodeIn_sub = comDe.g.nodeIn_n(startIndex);
    							com_sub = comDe.g.com_n(startIndex);
    							startIndex = startIndex + 1;
        					}
        					comDe.one_pass( id, startIndex, endIndex, args, comDe, indexs, com_sub, total_weight );
                		}
                			
                		else
                		{
                			var links_sub:Array[Links_opt] = new Array[Links_opt]((comDe.g.links.nodeSize - startIndex));
        					var node2com_sub:Array[Int] = new Array[Int]((comDe.g.links.nodeSize - startIndex));
        					var nodeIn_sub:Array[Double] = new Array[Double]((comDe.g.links.nodeSize - startIndex));
        					var com_sub:Array[Community] = new Array[Community]((comDe.g.links.nodeSize - startIndex));
        					for (var i:Int = 0; i < links_sub.size; i++ )
        					{
        					    links_sub( i ) = comDe.g.links(startIndex);
        						//links = comDe.g.links_n;
    							node2com_sub = comDe.g.node2com_n(startIndex);
    							nodeIn_sub = comDe.g.nodeIn_n(startIndex);
    							com_sub = comDe.g.com_n(startIndex);
    							startIndex = startIndex + 1;
        					}
        					comDe.one_pass( id, startIndex, comDe.g.links.size, args, comDe, indexs, com_sub, total_weight );
                		} 
                			
                	}
            	}   
            }   

    	    //moves = comDe.one_pass( args, comDe, indexs, com, total_weight );
	   
    	    Console.OUT.println("It moved " + comDe.moves + "times");
    	
    	    var endCompute:Long = timer.milliTime();
    	// Console.OUT.print("after::");
    	// display_com(comInfo_obj);	
    	 
    	 //display(links_opt,node2com,comInfo_obj);
    	 
    	   totalComputeTime = totalComputeTime+endCompute-startCompute;
    	   Console.OUT.println("compute time in  pass "+circleNum+"::"+(endCompute-startCompute)+"ms");
    	   clusterNum = 0;
    	   for(var i:Int = 0;i<comDe.g.com.size;i++)
    	   {
    		   if(!comDe.g.com(i).getNodeList().isEmpty())
    		   {
    			   clusterNum = clusterNum+1;
    		   }	
    	   }
    	 
    	   circleNum=circleNum+1; 	 
    	   outputStart = timer.milliTime();
    	 
    	   Console.OUT.println("Cluster Num is "+clusterNum);     
    	 
    	   com.setModularity(total_weight,comDe.g.com);
    	   mod = com.getModularity();

    	   com.resetNodeComWeightList( comDe );
    	   
    	   if(args.size >= 2 && args(1).equals("-o"))
    	   {
    		   isOne = true;
    		   
    	   }
    	   

    	   if ((preLevelMod!= 0.0 && mod - preLevelMod<= 0.0001) || preLevelClusterNum == clusterNum || clusterNum ==1 || mod > 1 || comDe.moves == 0) 
    	   {
    		   Console.OUT.println("----------------------------------------");
    		   Console.OUT.println("The Result is: ");
    		   if (mod < preLevelMod)
    		   {
    			   Console.OUT.println("Nodes: " + preLevelClusterNum);     
    			   Console.OUT.println("Mod: " + preLevelMod);
    		   }
    		   else
    		   {
    			   Console.OUT.println("Nodes: " + clusterNum);     
    			   Console.OUT.println("Mod: " + mod);	
    			}
    		ifCircle=false;
    		}   
    	}//end while
    	Console.OUT.println("The Last One: ");
    	Console.OUT.println("Last Nodes: " + clusterNum);
    	Console.OUT.println("Last Mod: " + mod);
        Console.OUT.println("Over!!");
        var end:Long = timer.milliTime();
        Console.OUT.println("It used "+(readEndTime-start)+"ms to read");
        Console.OUT.println("It used "+totalComputeTime+"ms to compute");
        Console.OUT.println("It used "+(end-outputStart)+"ms to output");
        Console.OUT.println("It used "+(end-start)+"ms total");
    }
}
