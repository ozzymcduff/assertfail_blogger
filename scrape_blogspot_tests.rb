require 'test/unit'
$:.unshift File.dirname(__FILE__)
require "scrape_blogspot"

class GivenHtml < Test::Unit::TestCase
  def setup
    File.open(File.join("fixture","sample.html"), "r") { |infile|
      @parser = ScrapeBlogspot.new(infile.read)
    }
  end

  # def teardown
  # end
  
  def test_title
    assert_equal "Mocking smurf datalayer",@parser.title
  end

  def test_content
    expected = 'Mocking is <span class="variant">quite a new concept for me since I\'ve mostly written unit-tests tha</span>t can be labelled "automatic test". But it looks pretty sweet to write real unit-tests where those apply. I\'m more than a bit impressed by the ease of testing code written in asp.net mvc.<br /><br />I had some trouble with method interception in Rhino and NUnit mock. Somehow the mocking failed for those frameworks. It was not a total dud since the mocking of properties worked. I spent a lot time yesterday trying to get it to work. Since a standard example from the web failed on my machine, I\'ve assumed that there isn\'t much to do. Since Rhino looks so sweet, I will try to find out why it fails some other day.<br /><br />What did work however was <a href="http://code.google.com/p/moq/">moq</a>:<br /><br /><span style="font-size:85%;">var Svc = new Mock<ismurfservice>();<br />Assert.IsNotNull(Svc);<br />controller.Svc = Svc.Object;<br /><br />Smurf smurf1 = SmurfTestHelper.GetSmurf();<br />Svc.Expect(e => e.GetSmurf(It.IsAny<guid>())).Returns(smurf1);</guid></ismurfservice></span><br /><br />As you can se from the example code I\'m doing things that are a bit nasty: Exposing the datalayer SmurfService in controller in order to be able to use it in the binding.'+
      "\n<div style=\"clear: both;\"></div>"
    assert_equal expected.gsub(/<br \/>/,"<br>").gsub(/\=>/,"=&gt;"), @parser.content
  end

  def test_labels
    #post-labels
    expected = ['c#','mocking','moq','rhino','unit-test']
    assert_equal expected, @parser.labels
  end

  def test_date_published
    expected = DateTime.new(2009,3,15,9,16,0,'+1')
    assert_equal expected, @parser.date_published
  end
end


class GivenHtml2 < Test::Unit::TestCase
  def setup
    File.open(File.join("fixture","sample2.html"), "r", :encoding => 'utf-8') { |infile|
      @parser = ScrapeBlogspot.new(infile.read)
    }
  end

  # def teardown
  # end
  
  def test_title
    assert_equal "Skånetrafiken",@parser.title
  end

  def test_content
    expected = 'I dusted off some <a href="https://github.com/wallymathieu/skanetrafiken">old code</a> that I\'ve written to query the API provided by <a href="http://www.labs.skanetrafiken.se/">Skånetrafiken</a>. I\'ve also published it to <a href="https://rubygems.org/gems/skanetrafiken">rubygems</a>. It\'s quite nice to work with soap using ruby.
<div style="clear: both;"></div>'
    assert_equal expected.gsub(/<br \/>/,"<br>").gsub(/\=>/,"=&gt;"), @parser.content
  end

  def test_labels
    #post-labels
    expected = ['ruby']
    assert_equal expected, @parser.labels
  end

  def test_date_published
    expected = DateTime.new(2013,9,21,20,41,0,'+2')#2013-09-21T20:41:00+02:00
    assert_equal expected, @parser.date_published
  end

end
