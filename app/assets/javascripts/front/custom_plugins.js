$(document).on('ready', function() {
  $("#input-b6").fileinput({
      showUpload: false,
      dropZoneEnabled: true,
      maxFileCount: 10,
      mainClass: "input-group-lg"
  });

  $("#input-b5").fileinput({
      showUpload: false,
      dropZoneEnabled: true,
      maxFileCount: 10,
      mainClass: "input-group-lg"
  });
});