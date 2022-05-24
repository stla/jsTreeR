var tree = null;

$(document).ready(function(){

  $("#navigator").on("click", "li.jstree-x", function(e){
    if(!$(this).hasClass("jstree-x")){
      alert("uuuu"); return;
    }
    //$(this).addClass("jstree-x");
    //alert($(this).attr("class"));
    //var classes = $(this).attr("class");
    //$(this).attr("class", classes.replace("jstree-x", ""));
    //alert($(this).attr("class"));
    //$($(this)[0]).addClass("jstree-open").removeClass("jstree-x");
//    if(tree === null){
//      tree = $("#navigator").jstree(true);
//    }
  //alert("ooo")
    console.log(tree);
    var id = this.id;
    console.log("id: ", id);
    //tree.activate_node(id);
    var node = tree.get_node(id); //tree._model.data[id];
    console.log("node: ", node);
    if(node.original.type === "folder"){
      var newnode = tree.create_node(id, {text: "uuu", type: "folder", children: false, "li_attr": {"class": "jstree-x"}});
      console.log(newnode);    //tree.load_node(node.node);
      //tree.load_node(id);
      var $that = $(this);
      setTimeout(function() {tree.open_node(id); $that.removeClass("jstree-x");}, 10);
      //alert($(this).attr("class"));
    }
  });

  $("#navigator").on("open_node.jstree close_node.jstree show_node.jstree  hide_node.jstree", function(e, node){
    console.log("nnnnnnnnnnnn", node);
    $(document.getElementsByClassName("jstree-x")).removeClass("jstree-x");
    //$(this).addClass("jstree-x");
  });

/*  $("#navigator").on("activate_node.jstree", function(e){
    alert("activated");
    var tree = $("#navigator").jstree(true);
    console.log(tree);
    var id = "j1_1";
    console.log("id: ", id);
    var node = tree._model.data[id];
    console.log("node: ", node);
    var newnode = tree.create_node(id, {text: "uuu", type: "file"});
    console.log(newnode);    //tree.load_node(node.node);
    //tree.load_node(id);
    setTimeout(function() {tree.open_node(id);}, 100);
  });*/

});
