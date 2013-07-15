import x10.util.*;
public class Links_opt {
    //var end_weight:Pair[Int,Double];
    var endNodeList:ArrayList[Pair[Int,Double]];
    //var checkList:HashSet[Int];
    var nodeComWeightList:HashMap[Int,Double];
    var nodeWeight:Double=0.0;  //Ki
    public def this(){
    	//checkList = new HashSet[Int]();
    	endNodeList = new ArrayList[Pair[Int,Double]]();
    	nodeComWeightList = new HashMap[Int,Double](10);
    }

    public def getEndNodeList(){
    	return endNodeList;
    }
  //  public def getCheckList(){
   // 	return checkList;
   // }
    public def getNodeComWeightList(){
    	return nodeComWeightList;
    }
    public def setNodeWeight(var value:Double)
    {
    	nodeWeight = value;
    }
    public def getNodeWeight()
    {
    	return nodeWeight;
    }
/*    public def add(var endId:Int,var weight:Double){
    	var set:Pair[Int,Double];
    	set=new Pair[Int,Double](endId,weight);
    	checkList.add(endId);
    	endNodeList.add(set);
    }*/

}