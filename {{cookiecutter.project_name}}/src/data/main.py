from prefect import flow

from extract import extract
from transform import transform
from load import load


@flow
def main() -> None:
    load(transform(extract()))


if __name__ == "__main__":
    main()
