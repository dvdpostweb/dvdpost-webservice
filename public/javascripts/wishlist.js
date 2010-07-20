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
          parent.parent().remove();
        },
        error: function() {
          $(this).html(content);
        }
      });
    };
    return false;
  });

  $(document).bind("fragmentChange.transit_or_history", function() {
    $.getScript($.queryString(document.location.href, { 'transit_or_history': $.fragment().transit_or_history }));
  });
  if ($.fragment().transit_or_history) {
    $(document).trigger("fragmentChange.transit_or_history");
  }
  $("a.transit_or_history").live("click", function() {
    html_item = $(this);
    content = html_item.html();
    html_item.html("Loading ...");
    $.ajax({
      url: html_item.attr('href'),
      type: 'GET',
      success: function(data) {
        $(".on-way-with-nav").html(data);
        $.setFragment({ transit_or_history: $.queryString(html_item.attr('href')).transit_or_history })
      },
      error: function() {
        html_item.html(content);
      }
    });
    return false;
  });

  $('.report_transit_item, .report_history_item').live('click', function(){
    url = $(this).attr('href');
    jQuery.facebox(function() {
      $.getScript(url, function(data) {
        jQuery.facebox(data);
      });
    });
    return false;
  });
  
  $('.add_problem_space a').live("click", function() {
    $('#add_problem').html("<p align='center'><img src='/images/loading.gif' /></p>");
  });
  $(".products-pagination a").live("click", function() {
    html_item = $(this);
    root_item = $(this).parent().parent().parent();
    content = html_item.parent().html();
    html_item.parent().html("Loading...");
    $.ajax({
      url: html_item.attr('href'),
      type: 'GET',
      success: function(data) {
        root_item.html(data);
      },
      error: function() {
        html_item.parent().html(content);
      }
    });
    return false;
  });
});
