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

      },

      resize: function(width, height) {

        // TODO: code to re-render the widget with a new size

      }

    };
  }
});
