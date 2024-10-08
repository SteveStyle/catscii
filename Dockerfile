FROM ubuntu:24.04

# Install required dependencies
RUN set -eux; \
    apt update; \
    apt install -y --no-install-recommends \
    curl ca-certificates gcc libc6-dev pkg-config libssl-dev \
    ;

# Install rustup
RUN set -eux; \
    curl --location --fail \
    "https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init" \
    --output rustup-init; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain stable; \
    rm rustup-init; 

# Add rustup to path, check that it works
ENV PATH=${PATH}:/root/.cargo/bin
RUN set -eux; \
    rustup --version;

# Copy sources and build them
WORKDIR /app
COPY src src
COPY Cargo.toml Cargo.lock ./
RUN set -eux; \
    cargo build --release; \
    cp target/release/catscii .

CMD ["/app/catscii"]