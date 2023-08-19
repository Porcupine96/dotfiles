import re
import sys

raw_diff = sys.argv[1]

image_pattern=r"(-|\+)\s*image:\s*(.*).*\/(.*):(.*)"

diff = {}
for match in re.findall(image_pattern, raw_diff):
  direction, organization, service, version = match
  current = diff.get(service, [])
  diff[service] = current + [(direction, organization, service, version)]

out_lines = []
for service, changes in diff.items():
  if len(changes) == 1:
    if changes[0][0] == "-":
      out_lines.append("removed: {}/{}:{}".format(*changes[0][1:]))
    elif changes[0][0] == "+":
      out_lines.append("added:   {}/{}:{}".format(*changes[0][1:]))
  elif len(changes) == 2:
    b = 0 if changes[0][0] == '-' else 1
    a = 1 - b
    before, after = changes[b], changes[a]
    
    if before[1] == after[1]:
      out_lines.append("updated: {}: {} -> {}".format(before[2], before[3], after[3]))
    else:
      out_lines.append("updated: {}/{}:{} -> {}/{}:{}".format(*before[1:], *after[1:]))
  else:
    raise Exception("Could not handle diff!")
        
print('\n'.join(out_lines))
