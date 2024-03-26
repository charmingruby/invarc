###################
# DATABASE        #
###################
.PHONY: new-mig
new-mig:
	mix ecto.gen.migration $(NAME)

###################
# SERVER          #
###################
.PHONY: run
run:
	mix phx.server

###################
# LINTING         #
###################
.PHONY: lint
lint:
	mix credo --strict