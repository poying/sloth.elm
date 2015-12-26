TESTS := $(wildcard tests/*.elm)
SLOTH := ./bin/sloth.js --root $(PWD)/tests

test: $(TESTS)
	@$(SLOTH) $^
