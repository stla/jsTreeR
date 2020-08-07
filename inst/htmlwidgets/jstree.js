HTMLWidgets.widget({

  name: 'jstree',

  type: 'output',

  factory: function(el, width, height) {

    var $el = $(el);
    var options = {};

    return {

      renderValue: function(x) {

        var plugins = [];
        if(x.checkbox) {
          plugins.push('checkbox');
        }
        if(x.search) {
          plugins.push('search');
        }
        if(x.dragAndDrop) {
          plugins.push('dnd');
        }
        if(x.types) {
          plugins.push('types');
        }
        if(x.unique) {
          plugins.push('unique');
        }
        if(x.sort) {
          plugins.push('sort');
        }
        if(x.wholerow) {
          plugins.push('wholerow');
        }
        if(x.contextMenu) {
          plugins.push('contextmenu');
        }
        options.plugins = plugins;

        options.core = {
          'data': x.data,
          'check_callback': x.checkCallback
        };

        $el.jstree(options);

        $el.on("ready.jstree", function(e, data) {
          console.log("ready", data.instance.get_json());
        });

        $el.on("move_node.jstree", function(e, data) {
          console.log("move", data.instance.get_json());
        });

        $el.on("changed.jstree", function(e, data) {
          console.log("changed", data.instance.get_json());
          console.log("selected:", data.instance.get_selected(true));
        });

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
