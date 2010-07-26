module ReportsHelper
  def link_to_report(text, order, status_code)
    link_to(text, order_report_path(:order_id => order.to_param, :status => status_code), :method => :post)
  end
end