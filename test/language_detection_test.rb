RAILS_ROOT = File.expand_path(File.dirname(__FILE__))

require 'test/unit'
require 'language_detection'

# IMPORTANTE: Estos tests no comprueban que el analizador devuelve los resultados correctos (es
# decir, identifica el idioma correctamente), sino que la interfaz funciona (es decir, que devuelve
# alguno cualquiera de los idiomas configurados)
class LanguageDetectionTest < Test::Unit::TestCase

  def test_classifier
    assert_kind_of(LanguageDetection::LanguageClassifier, "String".classifier)
    assert("String".classifier.class.ancestors.include?(Classifier::Bayes))
  end
  
  def test_languages_list
    %w{es en fr}.each do |lang|
      assert LanguageDetection::LanguageClassifier.languages.include?(lang)
    end
  end
  
  def test_language
    assert(%w{es en fr}.include?("String".language))
  end
  
  def test_train
    {
      'es' => 'Hola',
      'en' => 'Hello',
      'fr' => 'Salut'
    }.each do |lang, string|
      assert_equal(lang, (string.language = lang))
      assert_equal(lang, string.language)
    end
  end
end