import streams, os, httpclient, asyncdispatch, uuids, mimetypes, re

const filePath: string = "./downloaded_images/"

if paramCount() == 0:
    quit "Please specify image adress"

proc generateFileName(extension: string): string =
    let uuid = uuids.genUUID()
    $uuid & "." & extension

proc adressIsValid(adress: string): bool =
    re.find(adress, re"^(http(s):\/\/.)[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$") != -1

proc downloadImage(imageAdress: string) {.async.} =
    if not adressIsValid(imageAdress):
        quit "You must provide valid URL"
    let
      client = newHttpClient()
      result = client.get(imageAdress)
    if result.status == "200 OK":
        let fileName = generateFileName(newMimetypes().getExt(result.headers["Content-Type"]))
        let inputStream = newFileStream(filePath & fileName, fmWrite)
        inputStream.write(result.body)
        inputStream.close()
    
    client.close()

let imageAdress = paramStr(1)

waitFor downloadImage(imageAdress)