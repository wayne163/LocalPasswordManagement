#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'wayne'
import sys, os
import base64, hashlib
commands = {
	'add account': '1',
	'get password': '2',
	'update password': '3',
	'exit': '4'
}
file_path = '.db.txt'

def addNewLine(line):
	with open(file_path, 'a+') as f:
		f.write(line)

#combine newline into file: 'name, value'
def parseValue(name, password):
	return name + ', ' + password + '\n'

#parse line in text into [name,value]
def parseLine(line):
	return line.split(',')

def encryptValue(value):
	return base64.b64encode(str(value))

def decryptValue(value):
	return base64.b64decode(str(value))

def pwd(value):
	sha = hashlib.sha1()
	sha.update(value)
	sha.update('auto3d')
	return str(sha.hexdigest())

def findPassword(key):
	with open(file_path, 'r') as f:
		for line in f.readlines():
			linelist = parseLine(line)
			if key == linelist[0]:
				return linelist[1]
		print 'there is no corresponding name. '

def checkPassword(key, value):
	with open(file_path, 'r') as f:
		for line in f.readlines():
			linelist = parseLine(line)
			if key == linelist[0] and value == linelist[1].strip():
				return True
		return False

def checkName(key):
	with open(file_path, 'r') as f:
		for line in f.readlines():
			if key == parseLine(line)[0]:
				return False
	return True

def updateLine(key, value):
	temp_list = []
	with open(file_path, 'r') as f:
		for line in f.readlines():
			linelist = parseLine(line)
			if key == linelist[0]:
				temp_list .append(parseValue(key, value))
			else:
				temp_list.append(line)
	with open(file_path, 'w') as f:
		f.writelines(temp_list)



def addAccount():
	name = raw_input("please enter the website name: ")
	password = raw_input('please enter the corresponding password: ')
	name = encryptValue(name)
	if checkName(name):
		password = encryptValue(password)
		addNewLine(parseValue(name, password))
		print 'add account successfully!\n'
	else:
		print 'the account name has exists, please input again.\n'


def getPassword():
	name = raw_input('please enter the corresponding name of password: ')
	password = findPassword(encryptValue(name))
	print 'password of %s is %s\n' % (name, decryptValue(password))

def updatePassword():
	name = raw_input('please enter the corresponding name you want to update: ')
	password = raw_input('please enter the origin password: ')
	if not checkPassword(encryptValue(name), encryptValue(password)):
		print 'name or password error \n'
		return
	new_password = raw_input('please enter new password: ')
	updateLine(encryptValue(name), encryptValue(new_password))
	print 'update password successfully! \n'


def check_type(command_type):
	if command_type == commands['add account']:
		addAccount()
	elif command_type == commands['get password']:
		getPassword()
	elif command_type == commands['update password']:
		updatePassword()
	elif command_type == commands['exit']:
		sys.exit(0)
	else:
		print 'wrong item'
	init()

def login():
	password = raw_input('please input the password: ')
	with open(file_path, 'r') as f:
		if pwd(password) == f.readline().strip():
			return True
	return False
		

def register():
	password = raw_input('This is your first login, please set the login password: ')
	check_password = raw_input('Please confirm password: ')	
	if password == check_password:
		with open(file_path, 'w') as f:
			f.write(pwd(password)+'\n')
	else:
		print 'They are different, please input again'
		register()


def init():
	command_type = raw_input('please choose the number of action: \n' \
							'1. add an account. \n' \
							'2. get the password of account. \n' \
							'3. update password. \n' \
							'4. exit \n')
	check_type((command_type))

if __name__ == '__main__': 
	if os.path.exists(file_path):
		if login():
			init()
		else:
			print 'wrong password, please input again. '
			login()
	else:
		register()
		init()