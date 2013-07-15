import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
public class ComCal {
	var com_n:Array[Community]; //nodeList in com,totWeight,insideWeight
	var nodeInfo_n:Array[NodeInfo]; //comID,Ki
	var plusInsideWeight:Double=0.0;
	var minusInsideWeight:Double=0.0;
	var modularity:Double=0.0;
	public def this(){
		
	}
//	(frontID,endId,total_weight,nodeWeight,totWeight,insideWeight,Kitoin)
	 public def getGain(var frontID:Int,var endID:Int,var m:Double,var nodeWeight:Double,var totWeight:Double,var insideWeight:Double,var Kitoin:Double){
		var gain:Double;
		gain=0.0;
		var moveGain:Double;
		var removeGain:Double;
		moveGain=(insideWeight+Kitoin)/(2*m)-((totWeight+nodeWeight)/(2*m))*((totWeight+nodeWeight)/(2*m));
		removeGain=insideWeight/(2*m)-(totWeight/(2*m))*(totWeight/(2*m))-(nodeWeight/(2*m))*(nodeWeight/(2*m));
		gain=moveGain-removeGain;
		return gain;
	}
	 public def setKitoIn(var links:Array[Links],var hash_newCom:HashSet[Int],var newComId:Int,var startPos:Int,var endPos:Int){
		 plusInsideWeight=0.0;	
		// var newComId:Int=nodeInfo(endId).getComId();
		 //var hash_newCom:HashSet[Int]=comInfo(newComId).getNodeList();    
		 //plus and minus
		 if(startPos==0) startPos=startPos+1;
		 for(var j:Int=startPos-1;j<endPos-1;j++){	
			 if(hash_newCom.contains(links(j).getEndId()))
				 plusInsideWeight=plusInsideWeight+links(j).getEdgeWeight();		
		 }
	 }
	 public def setInsideWeight(var nodeId:Int,var endId:Int,var links:Array[Links],var hash_oldCom:HashSet[Int],var hash_newCom:HashSet[Int],var startPos:Int,var endPos:Int){
		minusInsideWeight=0.0;
		plusInsideWeight=0.0;	
		//plus and minus
		if(startPos==0) startPos=startPos+1;
		for(var j:Int=startPos-1;j<endPos-1;j++){	
				if(hash_newCom.contains(links(j).getEndId()))
					plusInsideWeight=plusInsideWeight+links(j).getEdgeWeight();		
				if(hash_oldCom.contains(links(j).getEndId()))		
					minusInsideWeight=minusInsideWeight+links(j).getEdgeWeight();		
		}
		//Console.OUT.println(getPlusInsideWeight()+"-"+getMinusInsideWeight());
	}
	 public def addNode(var nodeId:Int,var endId:Int,var links:Array[Links],var comInfo:Array[Community],var nodeInfo:Array[NodeInfo],var startPos:Int,var endPos:Int){
         
		  var oldComId:Int=nodeInfo(nodeId).getComId();
		  var newComId:Int=nodeInfo(endId).getComId();
		  var hash_oldCom:HashSet[Int]=comInfo(oldComId).getNodeList();
		  var hash_newCom:HashSet[Int]=comInfo(newComId).getNodeList();   
		 
		  setInsideWeight(nodeId,endId,links,hash_oldCom,hash_newCom,startPos,endPos);
		 
		  var Ki_node:Double=nodeInfo(nodeId).getNodeWeight();
		  nodeInfo(nodeId).setComId(newComId);
		  if(!hash_oldCom.isEmpty()){
			  if(comInfo(oldComId).getNodeList().contains(nodeId)){
			  comInfo(oldComId).getNodeList().remove(nodeId);
			  }
		  }
		  comInfo(oldComId).setTot(comInfo(oldComId).getTot()-Ki_node+getMinusInsideWeight());
		  comInfo(oldComId).setIn(comInfo(oldComId).getIn()-getMinusInsideWeight());
		  comInfo(newComId).getNodeList().add(nodeId);
		  comInfo(newComId).setTot(comInfo(newComId).getTot()+Ki_node-getPlusInsideWeight());
		  comInfo(newComId).setIn(comInfo(newComId).getIn()+getPlusInsideWeight());    
	      nodeInfo_n=nodeInfo;
		  com_n=comInfo;
	}
	public def setModularity(var total_weight:Int,comInfo:Array[Community]){
		modularity=0.0;
		for(var i:Int=0;i<comInfo.size;i++){
			if(comInfo(i).getTot()>0)
			modularity=modularity+comInfo(i).getIn()/total_weight-comInfo(i).getTot()/total_weight*comInfo(i).getTot()/total_weight;
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
	 public def getCom(){
		return com_n;
	}
	 public def getNodeInfo(){
		return nodeInfo_n;
	}
}