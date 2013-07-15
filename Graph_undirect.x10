import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
import x10.lang.*;

public class Graph_undirect {
	var total_weight:Double;
	var maxNodeId:Int;
	var edgeNum_n:Int=0;

	var node_com:HashMap[Int,Int]; //endId,edgeWeight,used in reset part
	var links:Array[Links_opt];
	var links_n:Array[Links_opt];
	
	var com:Array[Community];//nodeList in com,totWeight,insideWeight 
	var com_n:Array[Community];//nodeList in com,totWeight,insideWeight 
	
	var nodeIn:Array[Double];
	var nodeIn_n:Array[Double];
	
	var node2com:Array[Int];
	var node2com_n:Array[Int];
	
	public def this(){	}
	
	public  def this(var filename:String,var type_file:Int,var maxNode:Int,var edgeNum:Int){  //0ー重み付いてない　1-重み付いている

		Console.OUT.println("start init graph");

		//opt 
		com = new Array[Community](maxNode + 1);
		links = new Array[Links_opt]((maxNode + 1));
		node2com = new Array[Int]((maxNode + 1), (Int)=>0 );
		nodeIn = new Array[Double](maxNode + 1);
		
		val finput = new File(filename);
		var keys:Array[String];
		
		var weight:Double = 0.0;
		
		for(var i:Int = 0; i<maxNode+1; i++)
		{
			links(i) = new Links_opt();
			com(i) = new Community();
			nodeIn(i) = 0.0;
		}
		
		for(line in finput.lines())
		{
			keys = line.split(" ");
			
			var v0:Int = Int.parse(keys(0));
			var v1:Int = Int.parse(keys(1));
			
			var set:Pair[Int,Double];
			
			if(type_file == 1) weight = Double.parse(keys(2));
			else weight = 1.0;
			set = new Pair[Int,Double](v1,weight);
			
			if(!links(v0).endNodeList.contains(set))
			{
				links(v0).endNodeList.add(set);
				
				links(v0).nodeComWeightList.put(v1, weight);
			}
			
		    set = new Pair[Int,Double](v0,weight);
		    
		    if(!links(v1).endNodeList.contains(set))
		    {
		    	links(v1).endNodeList.add(set);
		    	
		    	links(v1).nodeComWeightList.put(v0, weight);
		    }
	
		}
		total_weight = 0.0;
		var nodeWeight:Double = 0.0;
		for(var i:Int = 0; i < links.size; i++ ){
		
			nodeWeight = 0.0;
			
			if(type_file == 1)
			{
				for(var j:Int = 0; j < links(i).endNodeList.size(); j++)
				{
					nodeWeight = nodeWeight + links(i).endNodeList(j).second;				
					total_weight = total_weight + links(i).endNodeList(j).second;
				}
				links(i).nodeWeight =  nodeWeight;
			}
			else 
				{
				total_weight = total_weight + links(i).endNodeList.size();
			    links(i).nodeWeight =  links(i).endNodeList.size();
				}
			
			com(i).totWeight = links(i).endNodeList.size();
			com(i).inWeight = 0.0;
			
			var hs:HashSet[Int];
			hs = new HashSet[Int]();
			hs.add(i);
			com(i).node_hash = hs;

			node2com(i) = i;
		
		}	
		Console.OUT.println("total_weight: " + total_weight );
	}
	
	public def resetGraph( var comDe:ComDetect_n, var clusterNum:Int){
		
		var k:Int=0;

		links_n = new Array[Links_opt](clusterNum);
		node2com_n = new Array[Int] (clusterNum);
		com_n = new Array[Community](clusterNum);
		nodeIn_n = new Array[Double](clusterNum);
		var index_n:Int = 0;
		var transComId:HashMap[Int,Int] = new HashMap[Int,Int]();
		
		for(var i:Int = 0;i<comDe.g.com.size;i++){
			if(!comDe.g.com(i).getNodeList().isEmpty())
			{   
				transComId.put(i,index_n);
				com_n(index_n) = new Community();
				com_n(index_n).setValue(comDe.g.com(i).getNodeList(),comDe.g.com(i).getTot(),comDe.g.com(i).getIn());
				node2com_n(index_n) = index_n;
				nodeIn_n(index_n) = comDe.g.com(i).getIn();
				index_n = index_n+1;
			}
		}	
	
		for(var i:Int = 0;i<com_n.size;i++){
			var endNodeList:HashSet[Int];
			endNodeList = com_n(i).getNodeList();
			
			val it: Iterator[Int]  = com_n(i).getNodeList().iterator();
			links_n(i) = new Links_opt();
			
			var sumWeight:Double=0.0;
			while (it.hasNext()) {
				var linkList:HashMap[Int,Double];
				linkList = comDe.g.links(it.next()).getNodeComWeightList();
				
				val it1 = linkList.entries().iterator();
				while(it1.hasNext())
				{
					var me:Map.Entry[Int,Double] = it1.next();
					var set:Pair[Int,Double];
									
					if( containsKey(transComId.get(me.getKey()).value, links_n(i).getEndNodeList()) != -1 && i!=transComId.get(me.getKey()).value)
					{
						var index:Int = 0;
						index = containsKey(transComId.get(me.getKey()).value, links_n(i).getEndNodeList());
						
						set = new Pair[Int,Double](transComId.get(me.getKey()).value,me.getValue() + links_n(i).endNodeList(index).second);
						
						links_n(i).endNodeList.remove(links_n(i).endNodeList(index));
						links_n(i).endNodeList.add(set);
						
						var value:Double = 0.0;
						
						var oldWeight:Box[Double] = links_n(i).getNodeComWeightList().get(transComId.get(me.getKey()).value);
						
						value = oldWeight.value + me.getValue();
						links_n(i).nodeComWeightList.remove(transComId.get(me.getKey()).value);
						links_n(i).nodeComWeightList.put(transComId.get(me.getKey()).value, value);
						
						
						sumWeight = sumWeight + me.getValue();
						
						edgeNum_n=edgeNum_n+1;
					}
					if( containsKey(transComId.get(me.getKey()).value, links_n(i).getEndNodeList()) == -1 && i!=transComId.get(me.getKey()).value)
					{
						set = new Pair[Int,Double](transComId.get(me.getKey()).value,me.getValue());
						//Console.OUT.println("start, newEnd, weight = " + i + ", " + transComId.get(me.getKey()).value +", " + me.getValue());
						links_n(i).getEndNodeList().add(set);
						links_n(i).getNodeComWeightList().put(transComId.get(me.getKey()).value,me.getValue());
						sumWeight = sumWeight + me.getValue();	
						edgeNum_n=edgeNum_n+1;
					}
				}
				
			}
			
			
			//Console.OUT.println("node i+sumWeight:"+i+"-"+sumWeight);
			links_n(i).getNodeComWeightList().put(i,com_n(i).getTot());
			links_n(i).setNodeWeight(sumWeight);
			com_n(i).getNodeList().clear();
			var hs:HashSet[Int]=new HashSet[Int]();
			hs.add(i);
			com_n(i).setNodeList(hs);
		}
	}
	public def containsKey(var nodeId:Int, var endNodeList:ArrayList[Pair[Int,Double]])
	{
		var result:Int = -1;
		
		for(var i:Int = 0; i < endNodeList.size(); i++ )
		{
			if(nodeId == endNodeList(i).first )
			{
				result = i;
			}
		}
		return result;
	}
    public static def main(args: Array[String]) {
        // TODO auto-generated stub
    	val timer = new Timer();
    	var start:Long = timer.milliTime();
    	var fileName:String = "../../Data/BlondelMethod/karate.txt";
    	val g = new Graph_undirect(fileName,0,33,77);
    	var end:Long = timer.milliTime();
    	Console.OUT.println("It used "+(end-start)+"ms");
    }
}
