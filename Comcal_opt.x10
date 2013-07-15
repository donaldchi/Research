import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
public class Comcal_opt {
	
	var plusInsideWeight:Double = 0.0;
	var minusInsideWeight:Double = 0.0;
	var modularity:Double = 0.0;
	public def this(){
		
	}
	
	public def getGain(var m:Double,var nodeWeight:Double,var totWeight:Double,var Kitoin:Double){
		var gain:Double;
		gain = 0.0;
	    gain = Kitoin - totWeight * nodeWeight / m;
	    //gain = gain / (2*m);
		return gain;
	}
	 public def setKitoIn(var endNodeList:ArrayList[Pair[Int,Double]],var hash_newCom:HashSet[Int]/*,var newComId:Int*/){
		 plusInsideWeight = 0.0;	
		 for(var j:Int = 0;j<endNodeList.size();j++){	
			 if(hash_newCom.contains(endNodeList(j).first))
				 plusInsideWeight = plusInsideWeight+endNodeList(j).second;		
		 }
	 }
	 public def setInsideWeight(var nodeId:Int, var endNodeList:ArrayList[Pair[Int,Double]], var hash_oldCom:HashSet[Int], var hash_newCom:HashSet[Int], var oldComId:Int, var newComId:Int, var node2com:Array[Int] ){	 
		minusInsideWeight = 0.0;
		plusInsideWeight = 0.0;	
		//plus and minus
		for(var j:Int = 0;j<endNodeList.size();j++){	
				if(newComId == node2com(endNodeList(j).first))
					plusInsideWeight = plusInsideWeight+endNodeList(j).second;		
				if(oldComId == node2com(endNodeList(j).first))		
					minusInsideWeight = minusInsideWeight+endNodeList(j).second;		
		}
	}
	
	public def setInsideWeight(var nodeId:Int, var checkList:HashSet[Int], var nodeComWeightList:HashMap[Int,Double],var oldComId:Int,var newComId:Int){	 
		 minusInsideWeight = 0.0;
		 plusInsideWeight = 0.0;	
		 //plus and minus
		 var weight:Box[Double];
		//Console.OUT.println("nodeId-oldComId-newComId-"+nodeId+"-"+oldComId+"-"+newComId);
        if(nodeComWeightList.containsKey(newComId))
        {
        	weight = nodeComWeightList.get(newComId);
        	plusInsideWeight = plusInsideWeight + weight.value;
        }
        if(nodeComWeightList.containsKey(oldComId))
        {
        	weight = nodeComWeightList.get(oldComId);
        	minusInsideWeight=minusInsideWeight+weight.value;
        }
       // Console.OUT.println("minusInsideWeight::"+minusInsideWeight);
       // Console.OUT.println("plusInsideWeight::"+plusInsideWeight);
	 }
	 public def addNode( var comDe:ComDetect_n,/*var checkList:HashSet[Int],*/var Ki_node:Double,var nodeId:Int,var endId:Int/*,var nodeComWeightList:HashMap[Int,Double]*/,var endNodeList:ArrayList[Pair[Int,Double]]){
		  var oldComId:Int = comDe.g.node2com(nodeId);
		  var newComId:Int = comDe.g.node2com(endId);

		  var hash_oldCom:HashSet[Int] = comDe.g.com(oldComId).getNodeList();
		  var hash_newCom:HashSet[Int] = comDe.g.com(newComId).getNodeList();   
		  
		 //Console.OUT.println("nodeId-oldComId-newComId-Ki_node"+nodeId+"-"+oldComId+"-"+newComId+"-"+Ki_node);
		  
		 setInsideWeight(nodeId, endNodeList, hash_oldCom, hash_newCom, oldComId, newComId, comDe.g.node2com);
		//   setInsideWeight(nodeId,checkList,nodeComWeightList,oldComId,newComId);
		  
		  
		  //var Ki_node:Double = endNodeList.size();
		  comDe.g.node2com(nodeId) = newComId;
		  if(!hash_oldCom.isEmpty()){
			  if(comDe.g.com(oldComId).getNodeList().contains(nodeId))
			  {
				  comDe.g.com(oldComId).getNodeList().remove(nodeId);
			  }
		  }
		  
		  //Console.OUT.println("nodeId: " + nodeId);
		  //Console.OUT.println("in addNode minusInsideWeight::"+getMinusInsideWeight());
		 /// Console.OUT.println("in addNode plusInsideWeight::"+getPlusInsideWeight());
		 // Console.OUT.println("ki_node, nodeIn(nodeId) " + Ki_node + ", " + nodeIn(nodeId) ); 
		  comDe.g.com(oldComId).setTot(comDe.g.com(oldComId).getTot() - Ki_node + getMinusInsideWeight()*2);
		  comDe.g.com(oldComId).setIn(comDe.g.com(oldComId).getIn() - getMinusInsideWeight()*2 -comDe.g.nodeIn(nodeId));
		  comDe.g.com(newComId).getNodeList().add(nodeId);
		  comDe.g.com(newComId).setTot(comDe.g.com(newComId).getTot() + Ki_node - getPlusInsideWeight()*2 );
		  comDe.g.com(newComId).setIn(comDe.g.com(newComId).getIn() + getPlusInsideWeight()*2 + comDe.g.nodeIn(nodeId));    
	      //node2com_n = node2com;
		  //com_n = comDe.g.com;
		  //comDe.g.com = null;
		  //return comDe.g.node2com;
	}
	public def setModularity(var total_weight:Double,comInfo:Array[Community]){
		modularity = 0.0;
		for(var i:Int = 0; i < comInfo.size; i++){
			if( comInfo(i).getTot() > 0 && comInfo(i).node_hash.size()!=0 )
			{
				var tot:Double = comInfo(i).getIn() + comInfo(i).getTot();
				var inWeight:Double = comInfo(i).getIn();
				//Console.OUT.println("comId, tot, in,total_Weight: " + i + ", " + comInfo(i).getTot() + ", " + comInfo(i).getIn() +", " + total_weight);
				modularity = modularity + inWeight/total_weight-(tot/total_weight)*(tot/total_weight);
			}
		}
	}
	public def resetNodeComWeightList( var comDe:ComDetect_n ){
		for(var i:Int = 0;i < comDe.g.links.size; i++){
			var endNodeList:ArrayList[Pair[Int,Double]];
			endNodeList = comDe.g.links(i).getEndNodeList();
			comDe.g.links(i).getNodeComWeightList().clear();
			//Console.OUT.println(endNodeList);
			for(var j:Int = 0;j < endNodeList.size();j++){
				//Console.OUT.println("start-endId--node2com::"+i+"---"+endNodeList(j).first+"--"+node2com(endNodeList(j).first));
				var hash_newCom:HashSet[Int] = comDe.g.com(comDe.g.node2com(endNodeList(j).first)).getNodeList();    
				if(!comDe.g.links(i).getNodeComWeightList().containsKey(comDe.g.node2com(endNodeList(j).first))){
				setKitoIn(endNodeList,hash_newCom/*,node2com(endNodeList(j).first)*/);
				//Console.OUT.println("start-com-weight:"+i+"--"+node2com(endNodeList(j).first)+"-"+getPlusInsideWeight());
				comDe.g.links(i).getNodeComWeightList().put(comDe.g.node2com(endNodeList(j).first),getPlusInsideWeight());					
				}
			}
		}
	}
	public def getModularity(){
		return modularity;
	}
	 public def getPlusInsideWeight(){
		return plusInsideWeight;
	}
	 public def getMinusInsideWeight(){
		return minusInsideWeight;
	}
}