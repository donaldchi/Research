import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
public class NodeInfo {
	var comId:Int=0;
    var nodeWeight:Double=0;
	public def this(){

	}
	public def this(var value1:Int,var value2:Double){
		comId=value1;
		nodeWeight=value2;
	}	
	public def getComId(){
		return comId;
	}
	public def getNodeWeight(){
		return nodeWeight;
	}
	public def setValue(var value1:Int,var value2:Double){
		comId=value1;
		nodeWeight=value2;
	}
	public def setComId(var value1:Int){
		comId=value1;
	}	
	public def setNodeWeight(var value:Double){
		nodeWeight=value;
	}
}