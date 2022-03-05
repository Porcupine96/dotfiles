#!/usr/bin/awk


/^Name/ {
	gsub(/Name *: /, "")
	name=$0
	required=1
	required_optionally=0
}

/^Optional For.*None/ {
	required_optionally=0
}

/^Required By.*None/ {
	required=0

	if (name && !required && !required_optionally) {
		print name
		name=0
	}
}
