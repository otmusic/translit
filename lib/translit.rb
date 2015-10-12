# coding: utf-8

module Translit
  def self.convert!(text, enforce_language = nil)
    language = if enforce_language
      enforce_input_language(enforce_language)
    else
      detect_input_language(text.split(/\s+/).first)
    end

    map = self.send(language.to_s).sort_by {|k,v| v.length <=>  k.length}
    map.each do |translit_key, translit_value|
      text.gsub!(translit_key.capitalize, translit_value.first)
      text.gsub!(translit_key, translit_value.last)
    end
    text
  end

  def self.convert(text, enforce_language = nil)
    convert!(text.dup, enforce_language)
  end

private
  def self.create_russian_map
    self.english.inject({}) do |acc, tuple|
      rus_up, rus_low = tuple.last
      eng_value       = tuple.first
      acc[rus_up]  ? acc[rus_up]  << eng_value.capitalize : acc[rus_up]  = [eng_value.capitalize]
      acc[rus_low] ? acc[rus_low] << eng_value            : acc[rus_low] = [eng_value]
      acc
    end
  end

  def self.detect_input_language(text)
    text.scan(/\w+/).empty? ? :russian : :english
  end

  def self.enforce_input_language(language)
    if language == :english
      :russian
    else
      :english
    end
  end

  def self.english
    { 'a' => %w(А а), 'b' => %w(Б б), 'v' => %w(В в), 'g' => %w(Г г), 'd' => %w(Д д), 'e' => %w(Е е), 'jo' => %w(Ё ё), 'yo' => %w(Ё ё), 'ö' => %w(Ё ё), 'zh' => %w(Ж ж),
      'z' => %w(З з), 'i' => %w(И и), 'j' => %w(Й й), 'k' => %w(К к), 'l' => %w(Л л), 'm' => %w(М м), 'n' => %w(Н н), 'o' => %w(О о), 'p' => %w(П п), 'r' => %w(Р р),
      's' => %w(С с), 't' => %w(Т т), 'u' => %w(У у), 'f' => %w(Ф ф), 'h' => %w(Х х), 'x' => %w(Кс кс), 'c' => %w(Ц ц), 'ch' => %w(Ч ч), 'sh' => %w(Ш ш), 'w' => %w(В в),
      'shh' => %w(Щ щ), 'sch' => %w(Щ щ), '#' => %w(Ъ ъ), 'y' => %w(Ы ы), '' => %w(Ь ь), 'je' => %w(Э э), 'ä' => %w(Э э), 'ju' => %w(Ю ю), 'yu' => %w(Ю ю),
      'ü' => %w(Ю ю), 'ya' => %w(Я я), 'ja' => %w(Я я), 'q' => %w(Я я)}
  end

  def self.russian
    @russian ||= create_russian_map
  end
end
