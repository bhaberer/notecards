# frozen_string_literal: true

module CardsHelper
  def day_of_the_week_for(card)
    Time.zone.local(card.year, card.month, card.day).strftime('%A')
  end
end
