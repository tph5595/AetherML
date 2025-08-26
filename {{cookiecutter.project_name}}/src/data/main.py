import extract
import transform
import load

def main():
    data = extract()
    data = transform(data)
    data = load(data)

if __name__ == "__main__":
    main()
