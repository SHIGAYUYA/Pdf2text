# coding: Shift_JIS

def pdf2text(t, pdffile)
	#�t�H���_�쐬
	dirname = pdffile.gsub(/.pdf/, "")
	dirname = dirname.gsub(/pdf\//, "")
	if !Dir.exist?(dirname) then
		Dir.mkdir(dirname)
	end

	#�{���i�[
	text = "" + t

	#���s�R�[�h
	text = text.gsub(/\r/, "")

	#�͕���
	chapters = Hash.new
	
	key = "Title\n"
	value = ""

	flow = Array.new
	flow << key
	mode_chap = 0

	File.open("option/"+dirname + ".txt", "r") do |f|
		f.each_line do |line|
			l = line.gsub(/\r/, "")
			if l =~ /^mode_chap=(\d)\n$/ then
				mode_chap = $1.to_i
			else
				flow << line.gsub(/\r/, "")
			end
		end
	end
	p mode_chap
	chapID = 1
	text.each_line do |line|
		
		#p line
		
		if mode_chap == 0 then	#�S����v
			if line == flow[chapID] then
				p line
  				chapters.store(key, value)
  				key = line
				value = ""
				flow[chapID] = key
				chapID = chapID + 1
			else
  				if line !~ /^\d\n$/ then
					value += line
				end
			end
		elsif mode_chap == 1 then	#�擪��v
			if flow[chapID] != nil && line.start_with?(flow[chapID].gsub(/\n/, "") ) then
				p line
  				chapters.store(key, value)
  				key = line
				value = ""
				flow[chapID] = key
				chapID = chapID + 1
			else
  				if line !~ /^\d\n$/ then
					value += line
				end
			end
		end
	end

	chapters.store(key, value)
	

	flow.each do |key| 
		if key != "Title\n" then
			#���s�̒P��̕�������
			chapters.store(key, chapters[key].gsub(/([a-zA-Z])-\n/){ $1 })
			#�s���I�h����ȊO�̉��s������
			chapters.store(key, chapters[key].gsub(/([^\.])\n/){ $1 + " " })
			#�s���I�h����ɉ��s
			chapters.store(key, chapters[key].gsub(/\.\s+([A-Z])/){ ".\n" + $1 })
			#e.g.\n�ւ̑Ή�
			chapters.store(key, chapters[key].gsub(/e\.g\.\n/){ "e.g." })
		end
	end


	#�����t�@�C���쐬
	filename = dirname +"/" + dirname + ".txt"

	File.open(filename, "w") do |f|
		flow.each do |key| 
			f.puts key
			f.puts chapters[key]
			f.puts ""
		end
	end

	#1�����Ƃɉ��s
	flow.each do |key| 
		if key != "Title\n" then
			#()������
			chapters.store(key, chapters[key].gsub(/\.\n/){ ".\n\n" })
		end
	end

	#�t�@�C�����ύX
	filename = dirname +"/"  + dirname +  "_dif.txt"

	File.open(filename, "w") do |f|
		flow.each do |key| 
			f.puts key
			f.puts chapters[key]
			f.puts ""
		end
	end
=begin 
	#()������
	flow.each do |key| 
		if key != "Title\n" then
			#()������
			chapters.store(key, chapters[key].gsub(/\([^)]*\)/){ "" })
		end
	end

	#�t�@�C�����ύX
	filename = dirname +"/"  + dirname +  "_no_()_dif.txt"

	File.open(filename, "w") do |f|
		flow.each do |key| 
			f.puts key
			f.puts chapters[key]
			f.puts ""
		end
	end
=end
end

def pdf_search()
	pdfs = []
	Dir.open("pdf") do |dir|
  		dir.each do |f|
			if f =~ /.*.pdf$/ then
				pdfs << f
			end
		end
	end
	return pdfs
end