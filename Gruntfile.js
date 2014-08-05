module.exports = function(grunt) {

  "use strict";

  grunt.initConfig({

    libFiles: [
      "src/**/*.purs",
      "bower_components/purescript-*/src/**/*.purs"
    ],

    clean: ["tmp", "output", "html/js/*"],

    pscMake: {
      lib: {
        src: ["<%=libFiles%>"]
      },
      tests: {
        src: ["tests/Tests.purs", "<%=libFiles%>"]
      }
    },

    dotPsci: ["<%=libFiles%>"],

    psc: {
      demo: {
        options: {
          module: ["Tutorial.Ractive.Demo"],
          main: false
        },
        src: ["src/Tutorial/Ractive/*.purs", "<%=libFiles%>"],
        dest: "html/js/demo.js"
      }
    },

    copy: [
      {
        expand: true,
        cwd: "output",
        src: ["**"],
        dest: "tmp/node_modules/"
      }, {
        src: [],
        dest: "tmp/index.js"
      }
    ],

    execute: {
      tests: {
        src: "tmp/index.js"
      }
    },

    stencil: {
      main: {
        options: {},
        files: {
          'html/templates/tut1/content.html': ['src/stencil/tut1/content.dot.html'],
          'html/templates/tut2/content.html': ['src/stencil/tut2/content.dot.html'],
        }
      }
    }
  });

  grunt.loadNpmTasks("grunt-contrib-copy");
  grunt.loadNpmTasks("grunt-contrib-clean");
  grunt.loadNpmTasks("grunt-execute")
  grunt.loadNpmTasks("grunt-purescript");
  grunt.loadNpmTasks('grunt-stencil');

  grunt.registerTask("test", ["pscMake:tests", "copy", "execute:tests"]);
  grunt.registerTask("demo", ["psc:demo"])
  grunt.registerTask("make", ["pscMake:lib", "dotPsci"]);
  grunt.registerTask("default", ["clean", "make", "demo" ]);
};
