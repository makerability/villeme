<items>

  <section class="Section" data-anchor="{ opts.type }">

    <div class="Section-header">
      <h1 class="Section-title">{ opts.title }</h1>
      <span class="Section-description"></span>
    </div>

    <div class="Grid Grid--withGutter">
      <item each={ opts.items } class="Event Event--newsFeed grid Grid-cell u-size4of12"></item>
    </div>

  </section>

  <style scoped>
    h1{

    }
  </style>

  <script>

    this.on('mount', function(){
      var bLazy;
      setTimeout(function () {
        blazy(revalidate);
      }, 600);

      blazy = function(callback){
        bLazy = new Blazy('');
        callback();
      };

      revalidate = function(){
        setTimeout(function () {
          bLazy.revalidate();
        }, 3000);
      }
    });

    this.timeouts = [];

    addTimer(){
      this.timeouts.push('timer')
    };

    removeTimer(){
      this.timeouts.pop()
    };

  </script>

</items>
