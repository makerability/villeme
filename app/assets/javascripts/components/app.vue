<style>
  .red {
    color: #f00;
  }
</style>

<template>
  <input v-model="msg">
  <h1 class="red">{{msg}}</h1>
</template>

<script>
export default {
  data () {
    return {
      msg: 'Hello world!'
    }
  }
}
</script>
