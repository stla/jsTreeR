var tree = null;

$(document).ready(function(){

  var Children = null;
  Shiny.addCustomMessageHandler("getChildren", function(x){
    console.log("x: ", x);
    Children = x;
  });

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
    if(tree.is_leaf(node) && node.original.type === "folder"){
      var path = tree.get_path(node, "/");
      Shiny.setInputValue("path", path);
      var interval = setInterval(function(){
        console.log("Children: ", Children);
        if(Children !== null){
          clearInterval(interval);
          for(var i = 0; i < Children.elem.length; i++){
            var isdir = Children.folder[i];
            var newnode = tree.create_node(id, {
              text: Children.elem[i],
              type: isdir ? "folder" : "file",
              children: false,
              "li_attr": isdir ? {"class": "jstree-x"} : null
            });
          }
          Children = null;
          setTimeout(function() {tree.open_node(id);}, 10);
        }
      }, 1000);
      //console.log(newnode);
    }
  });

/*  $("#navigator").on("show_node.jstree open_node.jstree", function(e, node){
    console.log("nnnnnnnnnnnn", node);
    //$(document.getElementById(node.node.id)).removeClass("jstree-x");
    //$(this).addClass("jstree-x");
  });  */

/*  $("#navigator").on("open_node.jstree close_node.jstree show_node.jstree  hide_node.jstree", function(e, node){
    console.log("nnnnnnnnnnnn", node);
    $(document.getElementsByClassName("jstree-x")).removeClass("jstree-x");
    //$(this).addClass("jstree-x");
  }); */

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
