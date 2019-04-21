const createSortUrl = adId => `/ads/${adId}/sort`;

document.addEventListener("turbolinks:load", () => {
  $(function() {
    $(".sortable").railsSortable();
  });

  $(".sort-drop-down").change(e => {
    $.ajax({
      url: createSortUrl(e.target.name),
      type: "PATCH",
      data: { sort: e.target.value }
    });
  });

  $(".content-button").on("click", e => {
    e.preventDefault();
    $(".content-preview").toggle("slow");
    $(".list-content-preview").toggle("slow");
  });
});
