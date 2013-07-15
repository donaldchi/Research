import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
import x10.lang.*;
public class Graph_opt {
	var total_weight:Double;
	var node_degree_int:Array[Int];//scope of the edge,used in reset part
	var node_com:HashMap[Int,Int]; //endId,edgeWeight,used in reset part
	//var nodeInfo_obj:Array[NodeInfo];
	var com_obj:Array[Community];//nodeList in com,totWeight,insideWeight
	//var links_new:Array[Links];//endId,edgeWeight
	var com_n:Array[Community]; //nodeList in com,totWeight,insideWeight
	//var nodeInfo_new:Array[NodeInfo]; //comID,Ki
	var maxNodeId:Int;
	//opt 
	var links_opt:Array[Links_opt];
	var node2com:Array[Int];
	var nodeIn:Array[Double];
	var links_n:Array[Links_opt];
	var node2com_n:Array[Int];
	var nodeIn_n:Array[Double];
	var edgeNum_n:Int=0;
	//
	public def this(){	}
	public  def this(var filename:String,var type_file:Int,var maxNode:Int,var edgeNum:Int){  //0ー重み付いてない　1-重み付いている
		total_weight = edgeNum;
     	node_degree_int = new Array[Int](maxNode + 2);
		com_obj = new Array[Community](maxNode + 1);
		//nodeInfo_obj = new Array[NodeInfo](maxNode+1);
		//opt 
		links_opt = new Array[Links_opt](maxNode + 1);
		node2com = new Array[Int](maxNode + 1);
		nodeIn = new Array[Double](maxNode + 1);
		//
		val finput = new File(filename);
		var keys:Array[String];
		//var index:Double = 0;
		var index_int:Int = 0;
		node_degree_int(index_int) = 0;
		//index = index+1;
		index_int = index_int+1;
		var frontId:Double = 0.0;
		var pos:Double = 1;
		var frontId_int:Int = 0;
		var pos_int:Int = 1;
		var Ki_int:Int = 0;
		var hs:HashSet[Int];
		var index_link:Int = 0;
		for(var i:Int = 0;i<maxNode+1;i++)
		{
			links_opt(i) = new Links_opt();
		}
		
		for(line in finput.lines()){
			
			keys = line.split(" ");
			//opt
			var weight:Double = 1.0;
			if(type_file == 1)
			{
				weight = Double.parse(keys(2));
			}
			var index_links:Int = Int.parse(keys(0));
			
			var set:Pair[Int,Double];
			set = new Pair[Int,Double](Int.parse(keys(1)),weight);
			//links_opt(index_links).getCheckList().add(Int.parse(keys(1)));
			
			//links_opt(Int.parse(keys(1))).getCheckList().add(index_links);
			
			links_opt(index_links).getEndNodeList().add(set);
			links_opt(index_links).getNodeComWeightList().put(Int.parse(keys(1)),weight);
			//
			if(Int.parse(keys(0))-frontId_int == 1){
				if(type_file == 0)
					{
					Ki_int = pos_int-node_degree_int(index_int-1);
					}
				node_degree_int(index_int) = pos_int;
				//nodeInfo_obj(index_int-1) = new NodeInfo();
				//nodeInfo_obj(index_int-1).setValue(index_int-1,Ki_int);
				//opt
				node2com(index_int-1) = index_int-1;
				nodeIn(index_int-1) = 0.0;
				//
				//total_weight = Ki_int+total_weight;
				hs = new HashSet[Int]();
		        hs.add(index_int-1);
		        com_obj(index_int-1) = new Community();
		        com_obj(index_int-1).setValue(hs,Ki_int,0.0);
		        links_opt(index_int-1).setNodeWeight(Ki_int);
				index_int = index_int+1;
				Ki_int = 0;
			}else if(Int.parse(keys(0))-frontId_int>1){	
				for(var j:Double = 0.0;j<Double.parse(keys(0))-frontId;j++){
					if(type_file == 0)
						{
						Ki_int = pos_int-node_degree_int(index_int-1);
						}
					node_degree_int(index_int) = pos_int;

					//opt
					node2com(index_int-1) = index_int-1;
					nodeIn(index_int-1) = 0.0;
					//
					hs = new HashSet[Int]();
					hs.add(index_int-1);
					com_obj(index_int-1) = new Community();
					com_obj(index_int-1).setValue(hs,Ki_int,0.0);
					links_opt(index_int-1).setNodeWeight(Ki_int);
					index_int = index_int+1;
				}
			}
            var edgeWeight:Double = 0.0;
			if(type_file == 0)
				{
				edgeWeight = 1.0;
				}
			else if(type_file == 1)
				{
				edgeWeight = Double.parse(keys(2));
				}
			index_link = index_link+1;
            frontId = Double.parse(keys(0));
            frontId_int = Int.parse(keys(0));
            pos = pos+1;
            pos_int = pos_int+1;
		} //end for
		node_degree_int(index_int) = pos_int;
		if(type_file == 0)
			{
			Ki_int = pos_int-node_degree_int(index_int-1);
			}
	//	nodeInfo_obj(index_int-1) = new NodeInfo();
	//	nodeInfo_obj(index_int-1).setValue(index_int-1,Ki_int);
		//opt
		node2com(index_int-1) = index_int-1;
		nodeIn(index_int-1) = 0.0;
		//
		//total_weight = Ki_int+total_weight-1;
		//set community IdList,totWeight,insideWeight
	    hs = new HashSet[Int]();
		hs.add(index_int-1);
		com_obj(index_int-1) = new Community();
		com_obj(index_int-1).setValue(hs,Ki_int,0.0);
		links_opt(index_int-1).setNodeWeight(Ki_int);
		com_obj(0).setTot(com_obj(0).getTot()-1);
		links_opt(0).setNodeWeight(com_obj(0).getTot());
	}
   	public def resetGraph(var links_old:Array[Links_opt],var com_old:Array[Community],var node2com:Array[Int],var clusterNum:Int){
   		
   		var k:Int=0;
 
   		com_n = new Array[Community](clusterNum);
   		links_n = new Array[Links_opt](clusterNum);
   		node2com_n = new Array[Int](clusterNum);
   		nodeIn_n = new Array[Double](clusterNum);
   		var index_n:Int = 0;
   		var transComId:HashMap[Int,Int] = new HashMap[Int,Int]();
   		for(var i:Int = 0;i<com_old.size;i++){
   			
   			if(!com_old(i).getNodeList().isEmpty())
   			{   
   				transComId.put(i,index_n);
   				com_n(index_n) = new Community();
   				com_n(index_n).setValue(com_old(i).getNodeList(),com_old(i).getTot(),com_old(i).getIn());
   				node2com_n(index_n) = index_n;
   				nodeIn_n(index_n) = com_old(i).getIn();
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
   				linkList = links_old(it.next()).getNodeComWeightList();
   				
   				val it1 = linkList.entries().iterator();
   				while(it1.hasNext())
   				{
   				var me:Map.Entry[Int,Double] = it1.next();
   				var set:Pair[Int,Double];
   				set = new Pair[Int,Double](transComId.get(me.getKey()).value,me.getValue());
   				
   				
   				
   				if(/*!links_n(i).getEndNodeList().contains(set)  &&*/ i!=transComId.get(me.getKey()).value)
   				   {

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
   	public def getEdgeNum_n(){
   		return edgeNum_n;
   	}
	public def getNode2Com(){
		return node2com;
	}
	public def getNode2Com_n(){
		return node2com_n;
	}
	public def getNodeIn(){
		return nodeIn;
	}
	public def getNodeIn_n(){
		return nodeIn_n;
	}
	public def getCom_obj(){
		return com_obj;
	}
	public def getCom_n(){
		return com_n;
	}
	public def getNodeDegree_int(){
		return node_degree_int;
	}
	//opt
	public def getLinks_opt(){
		return links_opt;
	}
	public def getLinks_n(){
		return links_n;
	}
	public def getTotalWeight(){
		return total_weight;
	}
	public static def main(args: Array[String]) {
		val timer = new Timer();
		var start:Long = timer.milliTime();
		var fileName:String = "../../Data/BlondelMethod/arxiv.txt";
		val g = new Graph(fileName,0,9376,48214);
		var end:Long = timer.milliTime();
		Console.OUT.println("It used "+(end-start)+"ms");
	}
}