module LocalesHelper
  def completeness_color(completeness)
    case completeness
    when 1 then "#0F0"
    when 0.95..1 then "#AE5"
    when 0.9..0.95 then "#EE4"
    when 0..0.9 then "#F55"
    end
  end
end
