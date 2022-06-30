#!/usr/bin/env python

def find_item(obj, field):
    if isinstance(obj, dict):
        for k, v in obj.items():
            if k == field:
                yield v
            elif isinstance(v, dict) or isinstance(v, list):
                yield from find_item(v, field)
    elif isinstance(obj, list):
        for v in obj:
            yield from find_item(v, field)

if __name__ == '__main__':
    obj = {"a":{"b":{"c":"d"}}}
    key = input("Enter the key:")
    print(next(find_item(obj, key), "No match found"))