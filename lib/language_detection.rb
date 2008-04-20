require 'singleton'
require 'rubygems'
require 'classifier'
require 'activesupport'

module LanguageDetection
  
  class LanguageClassifier < Classifier::Bayes
    
    @@samples_dir = "#{RAILS_ROOT}/lang"
    
    include Singleton
    
    cattr_accessor :samples_dir, :languages
    
    def initialize
      @@languages = Dir["#{@@samples_dir}/*"].map {|dir| dir.split('/').last}
      super(*@@languages)
      @@languages.each do |lang|
        Dir["#{@@samples_dir}/#{lang}/*.txt"].each do |file|
          train lang, File.read(file)
        end
      end      
    end
    
  end
  
  module Detection
    
    def classifier
      @classifier ||= LanguageClassifier.instance
    end
    
    def language
      @language ||= classifier.classify(self).downcase
    end
    
    def language=(lang)
      classifier.train(lang, self)
      @language = lang
    end
    
  end
end

String.send(:include, LanguageDetection::Detection)
