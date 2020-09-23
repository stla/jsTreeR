var copiedNode = null;

var binaryExtensions = [
	"3dm",
	"3ds",
	"3g2",
	"3gp",
	"7z",
	"a",
	"aac",
	"adp",
	"ai",
	"aif",
	"aiff",
	"alz",
	"ape",
	"apk",
	"appimage",
	"ar",
	"arj",
	"asf",
	"au",
	"avi",
	"bak",
	"baml",
	"bh",
	"bin",
	"bk",
	"bmp",
	"btif",
	"bz2",
	"bzip2",
	"cab",
	"caf",
	"cgm",
	"class",
	"cmx",
	"cpio",
	"cr2",
	"cur",
	"dat",
	"dcm",
	"deb",
	"dex",
	"djvu",
	"dll",
	"dmg",
	"dng",
	"doc",
	"docm",
	"docx",
	"dot",
	"dotm",
	"dra",
	"DS_Store",
	"dsk",
	"dts",
	"dtshd",
	"dvb",
	"dwg",
	"dxf",
	"ecelp4800",
	"ecelp7470",
	"ecelp9600",
	"egg",
	"eol",
	"eot",
	"epub",
	"exe",
	"f4v",
	"fbs",
	"fh",
	"fla",
	"flac",
	"flatpak",
	"fli",
	"flv",
	"fpx",
	"fst",
	"fvt",
	"g3",
	"gh",
	"gif",
	"graffle",
	"gz",
	"gzip",
	"h261",
	"h263",
	"h264",
	"icns",
	"ico",
	"ief",
	"img",
	"ipa",
	"iso",
	"jar",
	"jpeg",
	"jpg",
	"jpgv",
	"jpm",
	"jxr",
	"key",
	"ktx",
	"lha",
	"lib",
	"lvp",
	"lz",
	"lzh",
	"lzma",
	"lzo",
	"m3u",
	"m4a",
	"m4v",
	"mar",
	"mdi",
	"mht",
	"mid",
	"midi",
	"mj2",
	"mka",
	"mkv",
	"mmr",
	"mng",
	"mobi",
	"mov",
	"movie",
	"mp3",
	"mp4",
	"mp4a",
	"mpeg",
	"mpg",
	"mpga",
	"mxu",
	"nef",
	"npx",
	"numbers",
	"nupkg",
	"o",
	"oga",
	"ogg",
	"ogv",
	"otf",
	"pages",
	"pbm",
	"pcx",
	"pdb",
	"pdf",
	"pea",
	"pgm",
	"pic",
	"png",
	"pnm",
	"pot",
	"potm",
	"potx",
	"ppa",
	"ppam",
	"ppm",
	"pps",
	"ppsm",
	"ppsx",
	"ppt",
	"pptm",
	"pptx",
	"psd",
	"pya",
	"pyc",
	"pyo",
	"pyv",
	"qt",
	"rar",
	"ras",
	"raw",
	"resources",
	"rgb",
	"rip",
	"rlc",
	"rmf",
	"rmvb",
	"rpm",
	"rtf",
	"rz",
	"s3m",
	"s7z",
	"scpt",
	"sgi",
	"shar",
	"snap",
	"sil",
	"sketch",
	"slk",
	"smv",
	"snk",
	"so",
	"stl",
	"suo",
	"sub",
	"swf",
	"tar",
	"tbz",
	"tbz2",
	"tga",
	"tgz",
	"thmx",
	"tif",
	"tiff",
	"tlz",
	"ttc",
	"ttf",
	"txz",
	"udf",
	"uvh",
	"uvi",
	"uvm",
	"uvp",
	"uvs",
	"uvu",
	"viv",
	"vob",
	"war",
	"wav",
	"wax",
	"wbmp",
	"wdp",
	"weba",
	"webm",
	"webp",
	"whl",
	"wim",
	"wm",
	"wma",
	"wmv",
	"wmx",
	"woff",
	"woff2",
	"wrm",
	"wvx",
	"xbm",
	"xif",
	"xla",
	"xlam",
	"xls",
	"xlsb",
	"xlsm",
	"xlsx",
	"xlt",
	"xltm",
	"xltx",
	"xm",
	"xmind",
	"xpi",
	"xpm",
	"xwd",
	"xz",
	"z",
	"zip",
	"zipx"
];

function isBinary(ext) {
  return binaryExtensions.indexOf(ext) > -1;
}

function fileExtension(fileName) {
  if(/\./.test(fileName)) {
    var splitted = fileName.split(".");
    return splitted[splitted.length - 1].toLowerCase();
  } else {
    return null;
  }
}

function isImage(ext) {
  return imageExts.indexOf(ext) > -1;
}

function item_pdf(tree, node) {
  return {
    PDF: {
      separator_before: true,
      separator_after: true,
      label: "View PDF",
      action: function(obj) {
        Shiny.setInputValue("viewPDF", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep)
        }, { priority: "event" });
      }
    }
  };
}

function item_rerun(tree, node) {
  return {
    Rerun: {
      separator_before: true,
      separator_after: true,
      label: "Explore here",
      action: function(obj) {
        Shiny.setInputValue("rerun", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep)
        });
      }
    }
  };
}

function item_image(tree, node, ext) {
  return {
    Image: {
      separator_before: true,
      separator_after: true,
      label: "View image",
      action: function(obj) {
        Shiny.setInputValue("viewImage", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep),
          ext: ext
        }, { priority: "event" });
      }
    }
  };
}

function Items(tree, node, paste) {
  return {
    Copy: {
      separator_before: true,
      separator_after: false,
      label: "Copy",
      action: function(obj) {
        tree.copy(node);
        copiedNode = { node: node, operation: "copy" };
      }
    },
    Cut: {
      separator_before: false,
      separator_after: !paste,
      label: "Cut",
      action: function(obj) {
        tree.cut(node);
        copiedNode = { instance: tree, node: node, operation: "cut" };
      }
    },
    Paste: paste
      ? {
          separator_before: false,
          separator_after: true,
          label: "Paste",
          _disabled: copiedNode === null,
          action: function(obj) {
            var children = tree.get_node(node).children.map(function(child) {
              return tree.get_text(child);
            });
            if(children.indexOf(copiedNode.node.text) === -1) {
              var operation = copiedNode.operation;
              tree.copy_node(copiedNode.node, node, 0, function() {
                Shiny.setInputValue("operation", operation);
                setTimeout(function() {
                  Shiny.setInputValue("operation", "rename");
                }, 0);
              });
              if(operation === "cut") {
                copiedNode.instance.delete_node(copiedNode.node);
              }
              copiedNode = null;
            }
          }
        }
      : null,
    Rename: {
      separator_before: true,
      separator_after: false,
      label: "Rename",
      action: function(obj) {
        tree.edit(node, null, function() {
          var nodeType = tree.get_type(node);
          if(nodeType === "file" || exts.indexOf(nodeType) > -1) {
            var nodeText = tree.get_text(node);
            var ext = fileExtension(nodeText);
            if(ext !== null) {
              if(exts.indexOf(ext) > -1) {
                tree.set_type(node, ext);
              } else {
                tree.set_type(node, "file");
              }
            }
          }
        });
      }
    },
    Remove: {
      separator_before: false,
      separator_after: true,
      label: "Remove",
      action: function(obj) {
        if(Trash) {
          addTrashItem(
            tree.element.attr("id"),
            tree.get_path(node),
            extractKeysWithChildren(tree.get_json(node), ["text", "type"])
          );
        }
        tree.delete_node(node);
      }
    }
  };
}

function items_file(tree, node) {
  return {
    Open: {
      separator_before: true,
      separator_after: false,
      label: "Open in RStudio",
      _disabled: !rstudio,
      action: function(obj) {
        Shiny.setInputValue("openFile", {
          instance: tree.element.attr("id"),
          path: tree.get_path(node, sep)
        });
      }
    },
    Edit: {
      separator_before: false,
      separator_after: true,
      label: "Edit",
      action: function(obj) {
        Shiny.setInputValue(
          "editFile",
          { instance: tree.element.attr("id"), path: tree.get_path(node, sep) },
          { priority: "event" }
        );
      }
    }
  };
}

function item_create(tree, node) {
  return {
    Create: {
      separator_before: true,
      separator_after: true,
      label: "Create",
      action: false,
      submenu: {
        File: {
          separator_before: true,
          separator_after: false,
          label: "File",
          action: function(obj) {
            var children = tree.get_node(node).children.map(function(child) {
              return tree.get_text(child);
            });
            node = tree.create_node(node, { type: "file" });
            tree.edit(node, null, function() {
              var nodeText = tree.get_text(node);
              if(children.indexOf(nodeText) > -1) {
                tree.delete_node(node);
              } else {
                if(/\./.test(nodeText)) {
                  var splitted = nodeText.split(".");
                  var ext = splitted[splitted.length - 1].toLowerCase();
                  if(exts.indexOf(ext) > -1) {
                    tree.set_type(node, ext);
                  }
                }
                Shiny.setInputValue("createdNode", {
                  instance: tree.element.attr("id"),
                  type: "file",
                  path: tree.get_path(node, sep)
                });
              }
            });
          }
        },
        Folder: {
          separator_before: false,
          separator_after: true,
          label: "Folder",
          action: function(obj) {
            var children = tree.get_node(node).children.map(function(child) {
              return tree.get_text(child);
            });
            node = tree.create_node(node, { type: "folder" });
            tree.edit(node, null, function() {
              if(children.indexOf(tree.get_text(node)) > -1) {
                tree.delete_node(node);
              } else {
                Shiny.setInputValue("createdNode", {
                  instance: tree.element.attr("id"),
                  type: "folder",
                  path: tree.get_path(node, sep)
                });
              }
            });
          }
        }
      }
    }
  };
}
