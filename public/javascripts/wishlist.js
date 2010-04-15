$(function() {
  $(".wishlist_item_priority").live("click", function() {
    html_item = $(this).parent().parent()
    content = html_item.html();
    html_item.html("Updating...");
    wishlist_item_id = this.id;
    priority = this.value;
    $.ajax({
      url: '/fr/wishlist_items/' + wishlist_item_id,
      contentType: 'application/json; charset=utf-8',
      type: 'PUT',
      data: JSON.stringify({"wishlist_item": {"priority": priority}}),
      success: function(data) {
        html_item.html(data);
      },
      error: function() {
        html_item.html(content);
      }
    });
  });

  $(".trash a").live("click", function() {
    if (confirm('Are you sure?')) {
      content = $(this).html();
      parent = $(this).parent()
      parent.html("<img src='/images/ajax-loader.gif' />");
      $.ajax({
        url: $(this).attr('href'),
        type: 'DELETE',
        success: function() {
          alert('its gone!');
          parent.parent().remove();
        },
        error: function() {
          $(this).html(content);
        }
      });
    };
    return false;
  });
});
