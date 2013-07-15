import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
public class Community {
	var node_hash:HashSet[Int];
	var totWeight:Double=0.0;
	var inWeight:Double=0.0;
	public def this(){
		node_hash=new HashSet[Int](20);
	}
	public def this(var node_hash_out:HashSet[Int],var totWeight_out:Double,var inWeight_out:Double){
		 node_hash=new HashSet[Int](20);
		 node_hash=node_hash_out;
		 totWeight:Double=totWeight_out;
		 inWeight:Double=inWeight_out;	
	}	
	public def getNodeList(){
		return node_hash;
	}
	public def getTot(){
		return totWeight;
	}
	public def getIn(){
		return inWeight;
	}
	public def setValue(var value1:HashSet[Int],var value2:Double,var value3:Double){
		
		node_hash=value1;
		totWeight=value2;
		inWeight=value3;
	}
	public def setNodeList(var value:HashSet[Int]){
	    node_hash=value;
	}	
	public def setTot(var value:Double){
		totWeight=value;
	}
	public def setIn(var value:Double){
		 inWeight=value;
	}
}