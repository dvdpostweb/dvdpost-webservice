module ContestsHelper
  def question(contest)
    eval("contest.question_#{I18n.locale}")
  end

  def response(contest)
    eval("contest.choice_#{I18n.locale}").split('_')
  end

  def title(contest)
    eval("contest.title_#{I18n.locale}")
  end
end