import x10.io.File;
import x10.util.*;
import x10.util.ArrayList;
import x10.util.List; 
public class Links {
	var endId:Int=0;
    var edgeWeight:Double=0;
	public def this(){

	}
	public def this(var value1:Int,var value2:Double){
		endId=value1;
		edgeWeight=value2;
	}	
	public def getEndId(){
		return endId;
	}
	public def getEdgeWeight(){
		return edgeWeight;
	}
	public def setValue(var value1:Int,var value2:Double){
		endId=value1;
		edgeWeight=value2;
	}
	public def setEndId(var value1:Int){
		endId=value1;
	}	
	public def setEdgeWeight(var value:Double){
		edgeWeight=value;
	}
}