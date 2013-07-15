import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
public class Graph {
	var total_weight:Double;
	var node_degree:Array[Double]; //scope of the edge,used in reset part
	var node_degree_new:Array[Int];
	var node_degree_int:Array[Int];
	var node_com:HashMap[Int,Int]; //endId,edgeWeight,used in reset part
	var links_obj:Array[Links];
	var nodeInfo_obj:Array[NodeInfo];
	var com_obj:Array[Community];//nodeList in com,totWeight,insideWeight
	var links_new:Array[Links];//endId,edgeWeight
	var com_new:Array[Community]; //nodeList in com,totWeight,insideWeight
	var nodeInfo_new:Array[NodeInfo]; //comID,Ki
	var maxNodeId:Int;
	//opt 
	var links_opt:Array[Links_opt];
	//
	public def this(){	}
	public  def this(var filename:String,var type_file:Int,var maxNode:Int,var edgeNum:Int){  //0ー重み付いてない　1-重み付いている
		total_weight=edgeNum;
		node_degree=new Array[Double](maxNode+2);
     	node_degree_int=new Array[Int](maxNode+2);
		links_obj=new Array[Links](edgeNum);
		com_obj=new Array[Community](maxNode+1);
		nodeInfo_obj=new Array[NodeInfo](maxNode+1);
		//opt 
		links_opt=new Array[Links_opt](maxNode+1);
		//
		val finput=new File(filename);
		var keys:Array[String];
		//var index:Double=0;
		var index_int:Int=0;
		node_degree_int(index_int)=0;
		//index=index+1;
		index_int=index_int+1;
		var frontId:Double=0.0;
		var pos:Double=1;
		var frontId_int:Int=0;
		var pos_int:Int=1;
		var Ki_int:Int=0;
		var hs:HashSet[Int];
		var index_link:Int=0;
		for(line in finput.lines()){
			hs=new HashSet[Int]();
			keys=line.split(" ");
			//opt
			var weight:Double=1.0;
			if(type_file==1)
			{
				weight=Double.parse(keys(2));
			}
			var index_links:Int=Int.parse(keys(0));
			links_opt(index_links)=new Links_opt();
		//	links_opt(index_links).add(Int.parse(keys(1)),weight);
			//
			if(Int.parse(keys(0))-frontId_int==1){
				if(type_file==0)
					{
					Ki_int=pos_int-node_degree_int(index_int-1);
					}
				node_degree_int(index_int)=pos_int;
				nodeInfo_obj(index_int-1)=new NodeInfo();
				nodeInfo_obj(index_int-1).setValue(index_int-1,Ki_int);
				//total_weight=Ki_int+total_weight;
		        hs.add(index_int-1);
		        com_obj(index_int-1)=new Community();
		        com_obj(index_int-1).setValue(hs,Ki_int,0.0);
				index_int=index_int+1;
				Ki_int=0;
			}else if(Int.parse(keys(0))-frontId_int>1){	
				for(var j:Double=0.0;j<Double.parse(keys(0))-frontId;j++){
					if(type_file==0)
						{
						Ki_int=pos_int-node_degree_int(index_int-1);
						}
					node_degree_int(index_int)=pos_int;
					////set nodeInfo comId,Ki
					nodeInfo_obj(index_int-1)=new NodeInfo();
					nodeInfo_obj(index_int-1).setValue(index_int-1,Ki_int);
					
					//total_weight=Ki_int+total_weight;
					hs.add(index_int-1);
					com_obj(index_int-1)=new Community();
					com_obj(index_int-1).setValue(hs,Ki_int,0.0);
					index_int=index_int+1;
				}
			}
            var edgeWeight:Double=0.0;
			if(type_file==0)
				{
				edgeWeight=1.0;
				}
			else if(type_file==1)
				{
				edgeWeight=Double.parse(keys(2));
				}
			links_obj(index_link)=new Links();
			links_obj(index_link).setValue(Int.parse(keys(1)),edgeWeight);
			index_link=index_link+1;
            frontId=Double.parse(keys(0));
            frontId_int=Int.parse(keys(0));
            pos=pos+1;
            pos_int=pos_int+1;
		}
		node_degree_int(index_int)=pos_int;
		if(type_file==0)
			{
			Ki_int=pos_int-node_degree_int(index_int-1);
			}
		nodeInfo_obj(index_int-1)=new NodeInfo();
		nodeInfo_obj(index_int-1).setValue(index_int-1,Ki_int);
		//total_weight=Ki_int+total_weight-1;
		//set community IdList,totWeight,insideWeight
	    hs=new HashSet[Int]();
		hs.add(index_int-1);
		com_obj(index_int-1)=new Community();
		com_obj(index_int-1).setValue(hs,Ki_int,0.0);
		com_obj(0).setTot(com_obj(0).getTot()-1);		
		nodeInfo_obj(0).setNodeWeight(nodeInfo_obj(0).getNodeWeight()-1);
	}
	public def resetGraph(var node_degree_old:Array[Int],var links_old:Array[Links],var com_old:Array[Community],var nodeInfo_old:Array[NodeInfo],var clusterNum:Int){
        node_degree_new=new Array[Int](clusterNum+2);
        links_new=new Array[Links](links_obj.size);
        com_new=new Array[Community](clusterNum);
        nodeInfo_new=new Array[NodeInfo](clusterNum);
        Console.OUT.println("node_degree:"+node_degree_old.size); 
        Console.OUT.println("links_old:"+links_old.size);
        Console.OUT.println("com_old:"+com_old.size);
        Console.OUT.println("nodeInfo_old:"+nodeInfo_old.size);
        var index:Int=0;
        //nodeInfo_new(0).setValue(0,0.0);
        
        var hs:HashSet[Int];
        node_com=new HashMap[Int,Int](); 
        for(var i:Int=0;i<com_obj.size;i++){
        	if(com_obj(i).getIn()!=0.0){
        		
        		nodeInfo_new(index)=new NodeInfo();
        		nodeInfo_new(index).setValue(index,com_obj(i).getIn());

        		hs=new HashSet[Int]();
        		hs.add(index);
        		com_new(index)=new Community();
        		com_new(index).setValue(hs,com_obj(i).getTot(),com_obj(i).getIn()); 	
        		
        		val iterator: Iterator[Int] =com_obj(i).getNodeList().iterator();
        		while (iterator.hasNext()) {
        			var nodeID:Int=iterator.next();
                  //  Console.OUT.println("nodeID-com:"+nodeID+""+index);
        			node_com.put(nodeID,index);
        		}   		
        		
        		index=index+1;
        	}
        }
          var frontID:Int=0;
          var startPos_int:Int=0;
          var endPos_int:Int=0;
          Console.OUT.println("com_new:"+com_new.size);
          Console.OUT.println("nodeInfo_new:"+nodeInfo_new.size);
       /* for(var i:Int=1;i<node_degree_int.size;i++){		 	 
        	frontID=i-1;
        	startPos_int=node_degree_int(frontID);
        	endPos_int=node_degree_int(frontID+1);
        	if(startPos_int==0) startPos_int=startPos_int+1;
        	for(var j:Int=startPos_int-1;j<endPos_int-1;j++)
        		links_old(j).setEndId(nodeInfo_old(links_old(j).getEndId()).getComId());
        }*/  
          
          hs=new HashSet[Int]();
          index=0;
          var num:Double=1.0;
          
          for(var i:Int=0;i<com_new.size;i++){
        	  if(!com_new(i).getNodeList().isEmpty())
        	  {
        		  val iterator: Iterator[Int] =com_new(i).getNodeList().iterator();
        		  while (iterator.hasNext()) {
        			  var startIndex:Int=iterator.next();
        			  //links_old(startId).setEndId(i);
        			  var startId:Int=node_degree_int(startIndex);
        			  var endId:Int=node_degree_int(startIndex+1);
        			  if(startId==0) startId=startId+1;
        			  for(var j:Int=startId-1;j<endId-1;j++){
        				 
        				  links_new(index)=new Links();
        				  if(!hs.contains(node_com.get(j).value))
        				    {
        					  links_new(index).setValue(node_com.get(j).value,num);
        				      hs.add(node_com.get(j).value);
        				      index=index+1;
        				    }
        				  else 
        				   {
        					  
        				   }
        				  
        				  
        			  }
        		  }
        	  }
          }
          
	}
	public getCom_obj(){
		return com_obj;
	}
	public getNodeDegree_int(){
		return node_degree_int;
	}
	public getNodeDegree(){
		return node_degree;
	}
	public getLinks_obj(){
		return links_obj;
	}
	//opt
	public getLinks_opt(){
		return links_opt;
	}
	//
	public getNodeInfo_obj(){
		return nodeInfo_obj;
	}
	public getTotalWeight(){
		return total_weight;
	}
	public static def main(args: Array[String]) {
		val timer=new Timer();
		var start:Long=timer.milliTime();
		var fileName:String="../../Data/BlondelMethod/arxiv.txt";
		val g=new Graph(fileName,0,9376,48214);
		var end:Long=timer.milliTime();
		Console.OUT.println("It used "+(end-start)+"ms");
	}
}