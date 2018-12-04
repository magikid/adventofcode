input:=p1_input.txt
day:=$(shell date "+%-d")
folder:=day$(day)

new-day: $(folder) $(folder)/p1.rb $(folder)/p2.rb $(folder)/p1_input.txt $(folder)/p1_test.txt

$(folder):
	mkdir $(folder)

$(folder)/p1.rb:
	cp template.rb $(folder)/p1.rb

$(folder)/p2.rb:
	cp template.rb $(folder)/p2.rb

$(folder)/p1_input.txt:
	touch $(folder)/p1_input.txt

$(folder)/p1_test.txt:
	touch $(folder)/p1_test.txt

.PHONY: p1
p1:
	ruby $(folder)/p1.rb $(folder)/$(input)

.PHONY: p2
p2:
	ruby $(folder)/p2.rb $(folder)/$(input)
